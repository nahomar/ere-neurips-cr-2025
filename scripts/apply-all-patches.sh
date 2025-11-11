#!/bin/bash
# Apply all text-only patches for ERE NeurIPS 2025 camera-ready

set -e

echo "Applying all text-only patches..."

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "Error: Not in a git repository"
    echo "Please run this script from the root of the ere-neurips-cr-2025 repository"
    exit 1
fi

# Apply patches
echo "✓ Applying Issue #1 (AGI-FRAME)..."
git apply patches/issue-1-agi-frame.patch

echo "✓ Applying Issue #9 (REL-WORK-NS)..."
git apply patches/issue-9-rel-work-ns.patch

echo "✓ Applying Issue #10 (V2-MOVE)..."
git apply patches/issue-10-v2-move.patch

echo "✓ Applying Issue #11 (LIMITATIONS)..."
git apply patches/issue-11-limitations.patch

echo ""
echo "All patches applied successfully!"
echo ""
echo "Next steps:"
echo "1. Review changes: git diff"
echo "2. Commit changes: git commit -am 'Apply camera-ready fixes'"
echo "3. Push to branch: git push origin fix/camera-ready"
echo "4. Run experimental scripts: bash patches/run-experiments.sh"

