---
name: git-worktree-setup
description: Automate git worktree creation and copy private files (not tracked in git) to new workdirs. Use when creating a new git worktree for this Flutter project that requires untracked private files like secrets.dart, Firebase configs, etc.
---

# Git Worktree Setup

## Overview

Automates the creation of git worktrees and copies untracked private files to the new work directory. This skill handles the setup process for worktrees that require development-only files not committed to git (e.g., API keys, Firebase configs).

## Quick Start

Create a new worktree with private files copied:

```bash
scripts/setup_worktree.sh <worktree-name> [branch-name]
```

**Or copy private files to an existing worktree:**

```bash
scripts/setup_worktree.sh <existing-worktree-name>
```

**Example:**
```bash
# Create worktree for "feature-auth" branch
scripts/setup_worktree.sh feature-auth feature/auth

# Create worktree using main branch (default)
scripts/setup_worktree.sh hotfix-123

# Copy private files to an existing worktree
scripts/setup_worktree.sh feature-auth
```

The script:
1. Creates the worktree in `worktree/<worktree-name>` directory (if it doesn't exist)
2. Copies all files listed in `references/manifest.md` from the main repo (always runs)

## Managing Private Files

### Adding New Files

Edit `references/manifest.md` and add file paths relative to the repo root:

```markdown
- lib/common/secrets.dart
- ios/firebase_app_id_file.json
- macos/firebase_app_id_file.json
- android/app/google-services.json
```

### File Requirements

- All paths must be relative to the git repository root
- Target directories are created automatically if needed
- Missing source files are skipped with a warning (no error)

## Worktree Management

### Working in a Worktree

```bash
cd worktree/<worktree-name>
# Make changes, commits, etc.
```

### Removing a Worktree

```bash
git worktree remove worktree/<worktree-name>
```

### List All Worktrees

```bash
git worktree list
```

### Syncing Private Files to Existing Worktree

If you've updated private files in the main repo and want to sync them to an existing worktree:

```bash
scripts/setup_worktree.sh <existing-worktree-name>
```

The script will detect the existing worktree and skip the creation step, only copying the files from `references/manifest.md`. This is useful when:
- You've added new private files to the manifest
- You've updated file contents in the main repo
- You want to refresh private files in multiple worktrees

## Script Behavior

The `setup_worktree.sh` script automatically:
- Validates git repository context
- Creates the worktree directory structure (if needed)
- Detects existing worktrees and skips creation
- Copies private files using the manifest
- Provides colored output for status/warnings/errors

## Troubleshooting

**Directory exists but is not a git worktree**
```
ERROR: Directory exists but is not a git worktree: worktree/<name>
```
Remove the directory with `rm -rf worktree/<name>` or create a proper git worktree manually

**Syncing to existing worktree fails**
```
ERROR: Not in a git repository
```
Make sure you're running the script from within the main git repository

**Source file not found**
```
WARN: Source file not found: lib/common/secrets.dart, skipping...
```
The file is missing from your main repo; add it or remove from manifest

## Resources

### scripts/setup_worktree.sh
Executable shell script that creates git worktrees and copies private files. Execute directly without loading into context.

### references/manifest.md
Configuration file listing all private files to copy. Read this file to add or remove files that should be copied to new worktrees.
