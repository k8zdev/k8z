#!/bin/bash
# Git worktree setup script with private files copying
# Usage: ./setup_worktree.sh <worktree-name> [branch-name]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFEST_FILE="${SCRIPT_DIR}/../references/manifest.md"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Print colored message
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Parse manifest file to get private files list
parse_manifest() {
    if [[ ! -f "$MANIFEST_FILE" ]]; then
        print_error "Manifest file not found: $MANIFEST_FILE"
        exit 1
    fi

    # Extract file paths from manifest (lines starting with - )
    grep -E '^\s*-\s+' "$MANIFEST_FILE" | sed 's/^\s*-\s*//'
}

# Copy private file from original repo to worktree
copy_private_file() {
    local src_file="$1"
    local worktree_dir="$2"

    if [[ ! -f "$src_file" ]]; then
        print_warn "Source file not found: $src_file, skipping..."
        return
    fi

    local target_file="${worktree_dir}/${src_file}"
    local target_dir=$(dirname "$target_file")

    # Create target directory if it doesn't exist
    mkdir -p "$target_dir"

    # Copy the file
    cp "$src_file" "$target_file"
    print_info "Copied: $src_file"
}

# Create worktree and copy private files
main() {
    local worktree_name="$1"
    local branch_name="${2:-}"

    if [[ -z "$worktree_name" ]]; then
        print_error "Usage: $0 <worktree-name> [branch-name]"
        exit 1
    fi

    # Get the main repo directory (parent of scripts directory)
    local main_repo="$(cd "${SCRIPT_DIR}/../.." && pwd)"

    # Change to main repo
    cd "$main_repo"

    # Check if already in a git repo
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a git repository"
        exit 1
    fi

    # Determine branch name if not provided
    if [[ -z "$branch_name" ]]; then
        branch_name="main"
        print_info "No branch specified, using 'main'"
    fi

    local worktree_dir="${main_repo}/worktree/${worktree_name}"

    # Check if worktree directory exists
    local worktree_exists=false
    if [[ -d "$worktree_dir" ]]; then
        # Verify it's actually a git worktree
        if git worktree list | grep -q "$worktree_dir"; then
            worktree_exists=true
            print_info "Worktree already exists: $worktree_dir"
            print_info "Skipping worktree creation, only copying private files..."
        else
            print_error "Directory exists but is not a git worktree: $worktree_dir"
            print_info "Remove the directory or use git worktree add manually"
            exit 1
        fi
    fi

    if [[ "$worktree_exists" == false ]]; then
        # Create worktree directory parent if needed
        mkdir -p "$(dirname "$worktree_dir")"

        # Create the worktree
        print_info "Creating worktree at: $worktree_dir"
        print_info "Branch: $branch_name"
        git worktree add "$worktree_dir" "$branch_name"
    fi

    # Copy private files
    print_info "Copying private files..."
    cd "$main_repo"

    while IFS= read -r file; do
        [[ -n "$file" ]] || continue
        copy_private_file "$file" "$worktree_dir"
    done < <(parse_manifest)

    print_info "Worktree setup complete!"
    print_info "Worktree location: $worktree_dir"
    echo

    # Print usage tips
    echo "To work in this worktree:"
    echo "  cd $worktree_dir"
    echo ""
    echo "To remove this worktree when done:"
    echo "  git worktree remove $worktree_dir"
}

main "$@"
