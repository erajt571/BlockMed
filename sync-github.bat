@echo off
REM Simple script to fetch files from GitHub

setlocal enabledelayedexpansion

echo ===================================
echo BlockMed GitHub Sync Script
echo ===================================
echo.

echo Attempting to add GitHub remote and fetch latest changes...

cd /d "%~dp0"

REM Add remote if not exists
git remote add github https://github.com/erajt571/BlockMed.git 2>nul

REM Fetch from GitHub
git fetch github main

REM Merge if desired (optional)
REM git merge github/main

echo.
echo ✅ GitHub files synced!
echo.
echo To merge changes: git merge github/main
echo.
pause
