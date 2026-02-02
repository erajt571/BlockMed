# BlockMed GitHub Upload Script (PowerShell)
# This script uploads all files to the GitHub repository

Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "BlockMed GitHub Upload Script" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Configure git
Write-Host "1. Configuring git..." -ForegroundColor Yellow
git config --global user.email "dev@blockmed.local"
git config --global user.name "BlockMed Developer"

# Check if we're in a git repository
if (!(Test-Path .git)) {
    Write-Host "❌ Not a git repository. Initializing..." -ForegroundColor Red
    git init
}

# Check remote
Write-Host "2. Setting up GitHub remote..." -ForegroundColor Yellow
$remotes = git remote
if ($remotes -contains "origin") {
    Write-Host "✅ Remote 'origin' already exists" -ForegroundColor Green
} else {
    Write-Host "Adding GitHub remote..." -ForegroundColor Yellow
    git remote add origin https://github.com/erajt571/BlockMed.git
}

# View remote
Write-Host "📍 Remote URL:" -ForegroundColor Cyan
git remote -v

Write-Host ""
Write-Host "3. Staging all files..." -ForegroundColor Yellow
git add -A

Write-Host ""
Write-Host "4. Checking status..." -ForegroundColor Yellow
git status

Write-Host ""
Write-Host "5. Committing changes..." -ForegroundColor Yellow

$commitMessage = @"
Upload BlockMed V2 project with sync tools and documentation

- Added GitHub sync tools (Node.js, PowerShell, Bash)
- Added comprehensive documentation
- Added npm scripts for syncing
- Added setup and troubleshooting guides
- Project initialization and configuration
"@

git commit -m $commitMessage 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Changes committed" -ForegroundColor Green
} else {
    Write-Host "⚠️  No changes to commit or already committed" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "6. Pushing to GitHub..." -ForegroundColor Yellow
Write-Host "   Branch: main" -ForegroundColor Gray
Write-Host "   URL: https://github.com/erajt571/BlockMed.git" -ForegroundColor Gray
Write-Host ""

git push -u origin main

Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "✅ Upload Complete!" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Repository: https://github.com/erajt571/BlockMed" -ForegroundColor White
Write-Host "Branch: main" -ForegroundColor White
Write-Host ""
