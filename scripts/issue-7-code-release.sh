#!/bin/bash
# Issue #7: CODE-RELEASE - Tag repo, create Docker, publish checkpoint
# Requires: Hugging Face account, Docker Hub account

set -e

echo "Preparing v1.0-neurips25 release..."

# 1. Create Git tag
echo "Creating Git tag..."
git tag -a v1.0-neurips25 -m "NeurIPS 2025 camera-ready submission"
git push origin v1.0-neurips25

# 2. Build Docker container
echo "Building Docker container..."
docker build -t ere-research/ere-neurips25:v1.0 -f docker/Dockerfile .
docker tag ere-research/ere-neurips25:v1.0 ere-research/ere-neurips25:latest

# 3. Push to Docker Hub
echo "Pushing to Docker Hub..."
docker push ere-research/ere-neurips25:v1.0
docker push ere-research/ere-neurips25:latest

# 4. Create SHA-256 manifest for checkpoints
echo "Creating checkpoint manifest..."
cd checkpoints/ere-small-1.3b/checkpoint-50000
find . -type f -exec sha256sum {} \; > ../../../SHA256SUMS.txt
cd ../../..

# 5. Upload checkpoint to Hugging Face
echo "Uploading checkpoint to Hugging Face..."
python3 << EOF
from huggingface_hub import HfApi, create_repo

api = HfApi()

# Create repo if it doesn't exist
try:
    create_repo("ere-research/ere-small-1.3b-neurips25", repo_type="model")
except:
    pass

# Upload checkpoint
api.upload_folder(
    folder_path="checkpoints/ere-small-1.3b/checkpoint-50000",
    repo_id="ere-research/ere-small-1.3b-neurips25",
    repo_type="model"
)

# Upload SHA256 manifest
api.upload_file(
    path_or_fileobj="SHA256SUMS.txt",
    path_in_repo="SHA256SUMS.txt",
    repo_id="ere-research/ere-small-1.3b-neurips25",
    repo_type="model"
)

print("✓ Checkpoint uploaded to Hugging Face")
EOF

# 6. Create release notes
cat > RELEASE_NOTES.md << 'EOF'
# ERE v1.0 - NeurIPS 2025 Camera-Ready

## What's Included

- **ERE-small (1.3B)** checkpoint trained on CLADDER + Split-CIFAR-100
- **Docker container** for one-command reproduction
- **SHA-256 manifest** for all checkpoint files
- **Evaluation scripts** for CLADDER and continual learning benchmarks

## Quick Start

```bash
docker run -v $(pwd):/data ere-research/ere-neurips25:v1.0 \
    python scripts/eval_ere.py --dataset cladder
```

## Metrics

- CLADDER accuracy: 78.2%
- Split-CIFAR forgetting: 7.8%
- Cost: $84 per 1M queries

## Citation

```bibtex
@inproceedings{aregai2025ere,
  title={ERE: A Neuro-Symbolic Architecture for Verifiable Reasoning in High-Stakes Domains},
  author={Aregai, Nahom},
  booktitle={NeurIPS},
  year={2025}
}
```
EOF

echo "Release complete!"
echo "- Git tag: v1.0-neurips25"
echo "- Docker: ere-research/ere-neurips25:v1.0"
echo "- Hugging Face: ere-research/ere-small-1.3b-neurips25"
echo "- Release notes: RELEASE_NOTES.md"
