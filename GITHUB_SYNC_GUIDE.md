# GitHub Sync Instructions

If you need to sync all files from the GitHub repository, follow these steps:

## Quick Method: Using Git Remote

```bash
cd blockmed-v1.2-main

# Configure git
git config --global user.email "sync@blockmed.local"
git config --global user.name "BlockMed Sync"

# Add GitHub as remote
git remote add github-sync https://github.com/erajt571/BlockMed.git

# Fetch latest changes
git fetch github-sync main

# Merge if you want to update
git merge github-sync/main
```

## Using Node.js Script

```bash
node sync-github.js
```

This will download all files from the GitHub repository (excluding node_modules, .git, .env, etc.)

## Using Manual Zip Download

1. Visit: https://github.com/erajt571/BlockMed/archive/refs/heads/main.zip
2. Extract to a temporary folder
3. Copy files you need to the project

## Troubleshooting

If you encounter issues:

1. **Git Permission Denied**: 
   - Check SSH key or HTTPS credentials
   - Try: `git config --global credential.helper store`

2. **Slow Download**:
   - The script respects GitHub API rate limits
   - May take a few minutes for large repos

3. **Specific Files Only**:
   - Edit `sync-github.js` to modify `SKIP_PATTERNS`
   - Or manually download from: `https://raw.githubusercontent.com/erajt571/BlockMed/main/[FILE_PATH]`

## Files Available for Sync

- Source code in `src/`
- Contracts in `contracts/`
- Scripts in `scripts/`
- Documentation files
- Configuration files
- Test files

All while preserving your local `.env` and `node_modules/` folders.
