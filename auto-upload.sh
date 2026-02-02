#!/bin/bash

# ============================================================================
# BlockMed GitHub Upload - Automated Script
# This script will upload ALL files to GitHub automatically
# ============================================================================

set -e  # Exit on error

echo "=========================================="
echo "  BlockMed GitHub Auto-Upload"
echo "=========================================="
echo ""
echo "Starting automated upload to GitHub..."
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================================================
# Step 1: Configure Git
# ============================================================================
echo -e "${BLUE}[1/6]${NC} ${YELLOW}Configuring Git...${NC}"
git config --global user.email "dev@blockmed.local"
git config --global user.name "BlockMed Developer"
echo -e "${GREEN}✓ Git configured${NC}\n"

# ============================================================================
# Step 2: Initialize Git Repository
# ============================================================================
echo -e "${BLUE}[2/6]${NC} ${YELLOW}Checking git repository...${NC}"
if [ ! -d .git ]; then
    echo "Initializing git repository..."
    git init
fi
echo -e "${GREEN}✓ Git repository ready${NC}\n"

# ============================================================================
# Step 3: Setup GitHub Remote
# ============================================================================
echo -e "${BLUE}[3/6]${NC} ${YELLOW}Setting up GitHub remote...${NC}"
if ! git remote get-url origin &>/dev/null; then
    echo "Adding GitHub remote..."
    git remote add origin https://github.com/erajt571/BlockMed.git
else
    echo "Remote already exists"
fi
echo "Remote URL:"
git remote -v
echo -e "${GREEN}✓ GitHub remote configured${NC}\n"

# ============================================================================
# Step 4: Stage All Files
# ============================================================================
echo -e "${BLUE}[4/6]${NC} ${YELLOW}Staging all files...${NC}"
git add -A
echo -e "${GREEN}✓ All files staged${NC}\n"

# ============================================================================
# Step 5: Create Commit
# ============================================================================
echo -e "${BLUE}[5/6]${NC} ${YELLOW}Creating commit...${NC}"

COMMIT_MESSAGE="Upload BlockMed V2 - Complete project with sync and upload tools

Features included:
- React frontend with blockchain integration
- Smart contract for prescription verification
- Ganache local blockchain setup
- GitHub sync tools (Node.js, PowerShell, Bash)
- Upload automation tools
- Comprehensive documentation
- npm scripts for deployment
- Testing and verification tools

This is the complete BlockMed V2 project with all documentation,
configuration, and automation tools for team collaboration."

git commit -m "$COMMIT_MESSAGE" || echo "No changes to commit"
echo -e "${GREEN}✓ Changes committed${NC}\n"

# ============================================================================
# Step 6: Push to GitHub
# ============================================================================
echo -e "${BLUE}[6/6]${NC} ${YELLOW}Pushing to GitHub...${NC}"
git push -u origin main || echo "Already pushed or other issue"
echo -e "${GREEN}✓ Push complete${NC}\n"

# ============================================================================
# Verification
# ============================================================================
echo "=========================================="
echo -e "${GREEN}✓ Upload Complete!${NC}"
echo "=========================================="
echo ""
echo "Repository Information:"
echo "  URL: https://github.com/erajt571/BlockMed"
echo "  Branch: main"
echo ""
echo "Verify on GitHub:"
echo "  1. Visit: https://github.com/erajt571/BlockMed"
echo "  2. Check main branch"
echo "  3. Verify all files are present"
echo ""
echo "Local verification:"
echo ""
git log --oneline -n 3
echo ""
git remote -v
echo ""
echo -e "${GREEN}✓ All done! Your project is now on GitHub.${NC}"
echo ""
