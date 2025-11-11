#!/bin/bash
# Issue #2: GPT-4 Baseline Re-Run
# Runs CLADDER evaluation on GPT-4 with 10-shot CoT

set -e

echo "Running GPT-4 baseline evaluation..."

# Check for API key
if [ -z "$OPENAI_API_KEY" ]; then
    echo "Error: OPENAI_API_KEY not set"
    exit 1
fi

# Create output directory
mkdir -p results/baselines

# Run evaluation
python3 scripts/eval_baseline.py \
    --model gpt-4-0613 \
    --dataset cladder \
    --shots 10 \
    --temperature 0.0 \
    --output results/baselines/gpt4_cladder_10shot.jsonl

# Calculate accuracy
python3 scripts/calculate_accuracy.py \
    --input results/baselines/gpt4_cladder_10shot.jsonl \
    --output results/baselines/gpt4_accuracy.txt

echo "GPT-4 baseline complete!"
echo "Results saved to results/baselines/gpt4_cladder_10shot.jsonl"
echo "Accuracy: $(cat results/baselines/gpt4_accuracy.txt)"

# Estimated cost: ~$50 for full CLADDER test set
