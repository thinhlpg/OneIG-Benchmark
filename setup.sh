#!/bin/bash
# OneIG-Bench Setup Script for Homelab
# Adapted for CUDA 12.9, Python 3.12.12
# NOTE: This script should be run on the homelab Linux machine, not macOS

set -e

# Detect OS
OS=$(uname -s)
if [ "$OS" != "Linux" ]; then
    echo "⚠️  WARNING: This script is designed for Linux (homelab)."
    echo "   Current OS: $OS"
    echo "   Please run this on your homelab Linux machine."
    echo ""
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo "🚀 Setting up OneIG-Bench in homelab environment..."
echo "   CUDA: 12.9"
echo "   Python: 3.12.12"
echo "   OS: $OS"
echo ""

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo "❌ uv is not installed. Please install uv first:"
    echo "   curl -LsSf https://astral.sh/uv/install.sh | sh"
    exit 1
fi

# Create virtual environment
echo "📦 Creating virtual environment..."
uv venv .venv --python 3.12
source .venv/bin/activate

# Install PyTorch with CUDA 12.9 support
echo "🔥 Installing PyTorch 2.6.0 with CUDA 12.9 support..."
if [ "$OS" = "Linux" ]; then
    # Linux: Use CUDA wheels
    uv pip install torch==2.6.0 torchvision==0.21.0 --index-url https://download.pytorch.org/whl/cu124
else
    # macOS: Use CPU-only or MPS
    echo "   ⚠️  macOS detected - installing CPU-only PyTorch"
    uv pip install torch==2.6.0 torchvision==0.21.0
fi

# Install other requirements
echo "📚 Installing other dependencies..."
uv pip install transformers==4.50.0
uv pip install accelerate==1.4.0
uv pip install peft==0.17.1
uv pip install dreamsim
uv pip install openai-clip
uv pip install qwen_vl_utils
uv pip install pandas
uv pip install megfile

# Install triton (for flash-attention)
echo "⚡ Installing Triton..."
uv pip install triton==3.2.0

# Install flash-attention (for CUDA 12.9)
echo "⚡ Installing Flash Attention for CUDA 12.9..."
# Try to install from source if pre-built wheel not available
uv pip install flash-attn --no-build-isolation || {
    echo "⚠️  Flash-attention installation failed. You may need to install it manually:"
    echo "   git clone https://github.com/Dao-AILab/flash-attention.git"
    echo "   cd flash-attention && pip install ."
}

# Create directory structure
echo "📁 Creating directory structure..."
mkdir -p images/{anime,human,object,text,reasoning,multilingualism}
mkdir -p scripts/style/models
mkdir -p models

# Download required models
echo "⬇️  Downloading required models..."

# CSD model for style evaluation
if [ ! -f "scripts/style/models/csd_model.pth" ]; then
    echo "   Downloading CSD model..."
    echo "   ⚠️  Please download CSD model manually from:"
    echo "      https://drive.google.com/file/d/1FX0xs8p-C7Ob-h5Y4cUhTeOepHzXv_46/view?usp=sharing"
    echo "      Save as: scripts/style/models/csd_model.pth"
fi

# CLIP model
if [ ! -f "scripts/style/models/ViT-L-14.pt" ]; then
    echo "   Downloading CLIP ViT-L/14 model..."
    curl -L "https://openaipublic.azureedge.net/clip/models/b8cca3fd41ae0c99ba7e8951adf17d267cdb84cd88be6f7c2e0eca1737a03836/ViT-L-14.pt" \
        -o "scripts/style/models/ViT-L-14.pt" || {
        echo "   ⚠️  CLIP download failed. Please download manually:"
        echo "      https://openaipublic.azureedge.net/clip/models/b8cca3fd41ae0c99ba7e8951adf17d267cdb84cd88be6f7c2e0eca1737a03836/ViT-L-14.pt"
    }
fi

# DreamSim model for diversity
if [ ! -d "models/dreamsim_ensemble_checkpoint" ]; then
    echo "   Downloading DreamSim model..."
    echo "   ⚠️  Please download DreamSim manually from:"
    echo "      https://github.com/ssundaram21/dreamsim/releases/download/v0.2.0-checkpoints/dreamsim_ensemble_checkpoint.zip"
    echo "      Extract to: models/dreamsim_ensemble_checkpoint"
fi

# DINO model
if [ ! -f "models/dino_vitbase16_pretrain.pth" ]; then
    echo "   Downloading DINO model..."
    curl -L "https://dl.fbaipublicfiles.com/dino/dino_vitbase16_pretrain/dino_vitbase16_pretrain.pth" \
        -o "models/dino_vitbase16_pretrain.pth" || {
        echo "   ⚠️  DINO download failed. Please download manually:"
        echo "      https://dl.fbaipublicfiles.com/dino/dino_vitbase16_pretrain/dino_vitbase16_pretrain.pth"
    }
fi

# DINO repository (for diversity metrics)
if [ ! -d "models/dino" ]; then
    echo "   Cloning DINO repository..."
    git clone https://github.com/facebookresearch/dino.git models/dino || {
        echo "   ⚠️  DINO clone failed. Please clone manually:"
        echo "      git clone https://github.com/facebookresearch/dino.git models/dino"
    }
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "📝 Next steps:"
echo "   1. Download missing models (see warnings above)"
echo "   2. Activate environment: source .venv/bin/activate"
echo "   3. Generate images using: python text2image.py"
echo "   4. Run evaluation: bash run_overall.sh"
echo ""
echo "📖 See README.md for detailed usage instructions"
