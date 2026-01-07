#!/bin/bash
# OneIG-Bench Run Script
# Single source of truth for running OneIG-Bench

set -e

# Activate virtual environment
if [ -d ".venv" ]; then
    source .venv/bin/activate
else
    echo "❌ Virtual environment not found. Run setup.sh first."
    exit 1
fi

# Check if images directory exists
if [ ! -d "images" ]; then
    echo "❌ Images directory not found. Generate images first using text2image.py"
    exit 1
fi

# Default mode: EN (can be overridden)
MODE=${MODE:-EN}

# Default image directory
IMAGE_DIR=${IMAGE_DIR:-images}

# Default model names (can be overridden)
MODEL_NAMES=${MODEL_NAMES:-"janus-pro"}

# Default image grid (2 = 4 images per prompt)
IMAGE_GRID=${IMAGE_GRID:-2}

echo "🚀 Running OneIG-Bench Evaluation"
echo "   Mode: $MODE"
echo "   Image Directory: $IMAGE_DIR"
echo "   Models: $MODEL_NAMES"
echo "   Image Grid: $IMAGE_GRID"
echo ""

# Run overall evaluation
bash run_overall.sh

echo ""
echo "✅ Evaluation complete! Check results/ directory for outputs."
