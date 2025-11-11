# ERE: A Neuro-Symbolic Architecture for Verifiable Reasoning in High-Stakes Domains

[![Paper](https://img.shields.io/badge/Paper-NeurIPS%202025-blue)](paper/main.pdf)
[![Code](https://img.shields.io/badge/Code-GitHub-green)](https://github.com/ere-research/ere-neurips-cr-2025)
[![Model](https://img.shields.io/badge/Model-HuggingFace-yellow)](https://huggingface.co/ere-research/ere-small-1.3b-neurips25)

**NeurIPS 2025 Camera-Ready Submission**

## Overview

The Efficient Reasoning Engine (ERE) is a neuro-symbolic architecture for verifiable reasoning in high-stakes domains. This repository contains:

- **ERE (Hybrid)**: LLM-based architecture with causal reasoning and continual learning
- **ERE-0 (Zero-LLM)**: Neuro-symbolic architecture with 0% hallucination guarantee

## Quick Start

### Compile the Paper

```bash
cd paper/
pdflatex main.tex
bibtex main
pdflatex main.tex
pdflatex main.tex
```

### Run Baseline Evaluations

```bash
# Set API keys
export OPENAI_API_KEY=sk-...
export ANTHROPIC_API_KEY=sk-ant-...
export GOOGLE_API_KEY=...

# Run evaluations
bash scripts/issue-2-gpt4-base.sh
bash scripts/issue-3-claude-gem.sh
```

### Train ERE-Small (1.3B)

```bash
# Requires: 8x A100 GPUs, ~$1,800, 3 days
export WANDB_API_KEY=...
bash scripts/issue-6-spur-repro.sh
```

## Repository Structure

```
ere-neurips-cr-2025/
├── paper/              # LaTeX source files
│   ├── main.tex        # Main paper file
│   ├── references.bib  # Bibliography
│   └── *.png           # Figures
├── scripts/            # Experimental scripts
│   ├── issue-2-gpt4-base.sh
│   ├── issue-3-claude-gem.sh
│   ├── issue-6-spur-repro.sh
│   └── issue-7-code-release.sh
├── results/            # Experimental results
├── checkpoints/        # Model checkpoints
├── configs/            # Configuration files
└── docker/             # Docker files
```

## Key Results

| Model | CLADDER Acc | Split-CIFAR Forgetting | Cost ($/1M queries) |
|-------|-------------|------------------------|---------------------|
| ERE-0 | 89.7% | 4.8% | $34 |
| ERE-Hybrid | 78.2% | 12.3% | $84 |
| GPT-4 | 64.1% | 52.0% | $847 |

## Citation

```bibtex
@inproceedings{aregai2025ere,
  title={ERE: A Neuro-Symbolic Architecture for Verifiable Reasoning in High-Stakes Domains},
  author={Aregai, Nahom},
  booktitle={Advances in Neural Information Processing Systems},
  year={2025}
}
```

## License

MIT License - see LICENSE file for details

## Contact

Nahom Aregai - nahom.aregai@example.com

## Acknowledgments

This work was supported by [funding sources to be added].
