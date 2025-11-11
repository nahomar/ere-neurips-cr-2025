#!/bin/bash
# Issue #6: SPUR-REPRO - Train ERE-small (1.3B) for reproducibility
# Requires: 8x A100 40GB GPUs
# Duration: ~3 days
# Cost: ~$1,800

set -e

echo "Starting ERE-small (1.3B) training..."

# Check for required environment
if [ -z "$WANDB_API_KEY" ]; then
    echo "Warning: WANDB_API_KEY not set. Logging disabled."
fi

# Configuration
export MODEL_SIZE="1.3B"
export BACKBONE="mistralai/Mistral-1.3B-v0.1"
export NUM_EXPERTS=4
export DAG_NODES=200
export BATCH_SIZE=32
export LEARNING_RATE=1e-4
export WARMUP_STEPS=1000
export MAX_STEPS=50000
export SAVE_STEPS=5000

# Create output directory
mkdir -p checkpoints/ere-small-1.3b
mkdir -p logs

# Train the model
torchrun --nproc_per_node=8 \
    scripts/train_ere.py \
    --model_name_or_path $BACKBONE \
    --num_experts $NUM_EXPERTS \
    --dag_nodes $DAG_NODES \
    --per_device_train_batch_size $BATCH_SIZE \
    --learning_rate $LEARNING_RATE \
    --warmup_steps $WARMUP_STEPS \
    --max_steps $MAX_STEPS \
    --save_steps $SAVE_STEPS \
    --output_dir checkpoints/ere-small-1.3b \
    --logging_dir logs/ere-small-1.3b \
    --fp16 \
    --gradient_checkpointing \
    --deepspeed configs/ds_config_zero2.json \
    2>&1 | tee logs/training.log

echo "Training complete!"

# Evaluate on CLADDER
echo "Evaluating on CLADDER..."
python3 scripts/eval_ere.py \
    --model_path checkpoints/ere-small-1.3b/checkpoint-50000 \
    --dataset cladder \
    --output results/ere_small_cladder.jsonl

# Evaluate on Split-CIFAR-100
echo "Evaluating on Split-CIFAR-100..."
python3 scripts/eval_continual.py \
    --model_path checkpoints/ere-small-1.3b/checkpoint-50000 \
    --dataset split_cifar100 \
    --output results/ere_small_cifar.jsonl

# Calculate metrics
python3 scripts/calculate_metrics.py \
    --cladder_results results/ere_small_cladder.jsonl \
    --cifar_results results/ere_small_cifar.jsonl \
    --output results/ere_small_metrics.txt

echo "ERE-small evaluation complete!"
echo "Metrics: $(cat results/ere_small_metrics.txt)"

# Target metrics:
# CLADDER accuracy: >= 78%
# Split-CIFAR forgetting: <= 8%
