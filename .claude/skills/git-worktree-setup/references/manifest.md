# Private Files Manifest

This file lists the private files that should be copied to new git worktrees.

Each file path is relative to the repository root.

## Files to Copy

Add files below that should be copied to new worktrees. These files are typically
not tracked in git (e.g., listed in .gitignore) but are needed for local development.
- macos/k8z.dylib
- ios/libs/libk8z.a
- lib/common/secrets.dart
- ios/firebase_app_id_file.json
- macos/firebase_app_id_file.json
- lib/firebase_options.dart

## Adding New Files

To add a new private file:
1. Add a new line with the file path (relative to repo root)
2. Use the format: ` - path/to/file.ext`

## Notes
- All paths should be relative to the git repository root
- The script will create target directories if needed
- Missing source files are skipped with a warning
