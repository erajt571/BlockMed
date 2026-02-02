@echo off
REM BlockMed GitHub Upload Script (Batch)
REM This script uploads all files to the GitHub repository

echo.
echo ================================
echo BlockMed GitHub Upload Script
echo ================================
echo.

echo 1. Configuring git...
git config --global user.email "dev@blockmed.local"
git config --global user.name "BlockMed Developer"

echo 2. Setting up GitHub remote...
if not exist .git (
    echo Initializing git repository...
    git init
)

git remote get-url origin >nul 2>&1
if errorlevel 1 (
    echo Adding GitHub remote...
    git remote add origin https://github.com/erajt571/BlockMed.git
) else (
    echo Remote 'origin' already exists
)

echo.
echo Remote URL:
git remote -v

echo.
echo 3. Staging all files...
git add -A

echo.
echo 4. Checking status...
git status

echo.
echo 5. Committing changes...
git commit -m "Upload BlockMed V2 project with sync tools and documentation - Added GitHub sync tools (Node.js, PowerShell, Bash) - Added comprehensive documentation - Added npm scripts for syncing - Added setup and troubleshooting guides - Project initialization and configuration"

echo.
echo 6. Pushing to GitHub...
echo    Branch: main
echo    URL: https://github.com/erajt571/BlockMed.git
echo.

git push -u origin main

echo.
echo ================================
echo Upload Complete!
echo ================================
echo.
echo Repository: https://github.com/erajt571/BlockMed
echo Branch: main
echo.
pause
