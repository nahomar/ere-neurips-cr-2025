#!/bin/bash
# Quick Push Script - Run this after creating your GitHub repository

set -e

echo "ERE NeurIPS 2025 - Quick Push to GitHub"
echo "========================================"
echo ""

# Check if we're in the right directory
if [ ! -f "PUSH_TO_GITHUB.md" ]; then
    echo "Error: Please run this script from the ere-neurips-cr-2025 directory"
    exit 1
fi

# Prompt for GitHub username
read -p "Enter your GitHub username: " GITHUB_USERNAME

if [ -z "$GITHUB_USERNAME" ]; then
    echo "Error: GitHub username cannot be empty"
    exit 1
fi

echo ""
echo "Setting up remote..."
git remote add origin https://github.com/$GITHUB_USERNAME/ere-neurips-cr-2025.git 2>/dev/null || \
git remote set-url origin https://github.com/$GITHUB_USERNAME/ere-neurips-cr-2025.git

echo "Remote set to: https://github.com/$GITHUB_USERNAME/ere-neurips-cr-2025.git"
echo ""
echo "Pushing to GitHub..."
echo ""
echo "You will be prompted for your GitHub credentials:"
echo "  Username: $GITHUB_USERNAME"
echo "  Password: Use a Personal Access Token (NOT your password)"
echo ""
echo "Get a token at: https://github.com/settings/tokens"
echo ""

git push -u origin main

echo ""
echo "✅ Successfully pushed to GitHub!"
echo ""
echo "View your repository at:"
echo "https://github.com/$GITHUB_USERNAME/ere-neurips-cr-2025"
echo ""
echo "Next steps:"
echo "1. Make repository private (if needed)"
echo "2. Run experimental scripts (see README.md)"
echo "3. Submit to NeurIPS 2025!"
