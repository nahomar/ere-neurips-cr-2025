#!/bin/bash
# Issue #3: Claude-3 and Gemini-1.5 Baseline Re-Run
# Runs CLADDER evaluation on Claude and Gemini with 10-shot CoT

set -e

echo "Running Claude-3 and Gemini-1.5 baseline evaluations..."

# Check for API keys
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "Error: ANTHROPIC_API_KEY not set"
    exit 1
fi

if [ -z "$GOOGLE_API_KEY" ]; then
    echo "Error: GOOGLE_API_KEY not set"
    exit 1
fi

# Create output directory
mkdir -p results/baselines

# Run Claude-3 evaluation
echo "Evaluating Claude-3-Opus..."
python3 scripts/eval_baseline.py \
    --model claude-3-opus-20240229 \
    --dataset cladder \
    --shots 10 \
    --temperature 0.0 \
    --output results/baselines/claude3_cladder_10shot.jsonl

# Run Gemini-1.5 evaluation
echo "Evaluating Gemini-1.5-Pro..."
python3 scripts/eval_baseline.py \
    --model gemini-1.5-pro-latest \
    --dataset cladder \
    --shots 10 \
    --temperature 0.0 \
    --output results/baselines/gemini15_cladder_10shot.jsonl

# Calculate accuracies
python3 scripts/calculate_accuracy.py \
    --input results/baselines/claude3_cladder_10shot.jsonl \
    --output results/baselines/claude3_accuracy.txt

python3 scripts/calculate_accuracy.py \
    --input results/baselines/gemini15_cladder_10shot.jsonl \
    --output results/baselines/gemini15_accuracy.txt

echo "Baseline evaluations complete!"
echo "Claude-3 accuracy: $(cat results/baselines/claude3_accuracy.txt)"
echo "Gemini-1.5 accuracy: $(cat results/baselines/gemini15_accuracy.txt)"

# Estimated cost: ~$50 total for both models
