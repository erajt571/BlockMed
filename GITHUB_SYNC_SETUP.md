# 🔄 GitHub Sync Setup Complete!

## Quick Access

You can now sync files from the GitHub repository using any of these methods:

### **Method 1: Node.js Script (Recommended)**
```bash
npm run sync:github
```
Downloads all files from the GitHub repo using Node.js. Files are skipped: node_modules, .env, .git, dist, build

### **Method 2: PowerShell (Windows)**
```powershell
npm run sync:github:ps
```
Or directly:
```powershell
powershell -ExecutionPolicy Bypass -File sync-github.ps1 -Force
```

### **Method 3: Git Remote (Advanced)**
```bash
npm run sync:github:git
```
Or manually:
```bash
git remote add github-sync https://github.com/erajt571/BlockMed.git
git fetch github-sync main
git merge github-sync/main
```

---

## What Gets Synced?

✅ **Includes:**
- Source code (`src/`)
- Smart contracts (`contracts/`)
- Scripts and deployments (`scripts/`)
- Documentation files
- Configuration files
- Test files

🚫 **Excludes (to preserve local state):**
- `node_modules/` (use npm install)
- `.git/` (your git history)
- `.env` (your environment secrets)
- `package-lock.json` (use npm install)
- `dist/` (build output)
- `.DS_Store` (OS files)

---

## Workflow

### First Time Setup
```bash
# 1. Clone the project
git clone <your-fork-url>

# 2. Install dependencies
npm install --legacy-peer-deps

# 3. Sync GitHub files if needed
npm run sync:github
```

### Regular Updates
```bash
# Sync latest changes from GitHub
npm run sync:github

# Reinstall deps if needed
npm install --legacy-peer-deps

# Start development
npm run dev
```

---

## Troubleshooting

### "Module not found" after sync
```bash
npm install --legacy-peer-deps
npm run build
```

### Port already in use
```bash
npm run ganache:kill
npm run dev
```

### Git merge conflicts during sync
```bash
# Abort merge
git merge --abort

# Try again
npm run sync:github
```

### Rate limit exceeded
GitHub API limits unauthenticated requests to 60/hour. Wait a few minutes or:

**Option A:** Use Git instead of API
```bash
npm run sync:github:git
```

**Option B:** Authenticate with token (advanced)
Edit `sync-github.js` and add headers:
```javascript
headers: { 
  'Authorization': 'token YOUR_GITHUB_TOKEN'
}
```

---

## File Structure After Sync

```
blockmed-v1.2-main/
├── src/
│   ├── components/
│   ├── pages/
│   ├── hooks/
│   ├── utils/
│   ├── store/
│   └── App.jsx
├── contracts/
│   └── BlockMedV2.sol
├── scripts/
│   ├── deploy.cjs
│   └── check-and-deploy.cjs
├── test/
│   └── BlockMedV2.test.cjs
├── .env (DO NOT SYNC - LOCAL ONLY)
├── package.json (updated with sync scripts)
└── node_modules/ (DO NOT SYNC)
```

---

## Integration with CI/CD

The sync scripts are perfect for GitHub Actions:

```yaml
- name: Sync from GitHub
  run: npm run sync:github

- name: Build
  run: npm run build

- name: Deploy
  run: npm run deploy:polygon
```

---

## Manual Download Alternative

If scripting fails, download manually:

1. Visit: https://github.com/erajt571/BlockMed/archive/refs/heads/main.zip
2. Extract to temp folder
3. Copy individual files you need
4. Keep your `.env` and `node_modules/` intact

---

## Next Steps

1. ✅ Sync tools are ready to use
2. ✅ npm scripts added to package.json
3. ✅ Prevention safeguards in place (from previous setup)

### To sync right now:
```bash
npm run sync:github
```

### To start development:
```bash
npm run dev
```

---

**Questions?** Check [GITHUB_SYNC_GUIDE.md](./GITHUB_SYNC_GUIDE.md) for more details.
