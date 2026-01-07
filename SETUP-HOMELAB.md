# OneIG-Bench Homelab Setup Instructions

## Prerequisites

This benchmark should be set up on your **homelab Linux machine** (CachyOS), not on macOS.

## Remote Setup (from Mac to Homelab)

### Option 1: SSH and Run Setup

```bash
# From your Mac, SSH to homelab
ssh thinhlpg@homelab-ip

# Navigate to code directory
cd ~/code/oneig-benchmark

# Run setup
bash setup.sh
```

### Option 2: Use Remote Machine Management

If you have the `remote-machine-management` skill configured:

```bash
# From Mac, send setup command to homelab
# (Use your configured remote management tool)
```

## Local Setup (on Homelab)

If you're already on the homelab machine:

```bash
cd ~/code/oneig-benchmark
bash setup.sh
```

## What the Setup Script Does

1. ✅ Creates Python 3.12 virtual environment using `uv`
2. ✅ Installs PyTorch 2.6.0 with CUDA 12.9 support
3. ✅ Installs all required dependencies
4. ✅ Creates directory structure for images and models
5. ⚠️  Downloads some models automatically (CLIP, DINO)
6. ⚠️  Provides instructions for manual model downloads

## Manual Model Downloads Required

After setup, you need to download these models manually:

### 1. CSD Model (Style Evaluation)
- **Source**: https://drive.google.com/file/d/1FX0xs8p-C7Ob-h5Y4cUhTeOepHzXv_46/view?usp=sharing
- **Save to**: `scripts/style/models/csd_model.pth`
- **Size**: ~500MB

### 2. DreamSim Model (Diversity Metrics)
- **Source**: https://github.com/ssundaram21/dreamsim/releases/download/v0.2.0-checkpoints/dreamsim_ensemble_checkpoint.zip
- **Extract to**: `models/dreamsim_ensemble_checkpoint/`
- **Size**: ~200MB

### 3. OneIG-StyleEncoder (Optional)
- **Source**: https://huggingface.co/xingpng/OneIG-StyleEncoder
- **Save to**: `scripts/style/models/`

## Verification

After setup, verify installation:

```bash
source .venv/bin/activate
python -c "import torch; print(f'PyTorch: {torch.__version__}'); print(f'CUDA available: {torch.cuda.is_available()}'); print(f'CUDA version: {torch.version.cuda if torch.cuda.is_available() else \"N/A\"}')"
```

Expected output:
```
PyTorch: 2.6.0+cu124
CUDA available: True
CUDA version: 12.4
```

## Next Steps

1. **Generate Images**: Modify `text2image.py` with your model inference
2. **Run Evaluation**: Use `bash run.sh` or individual metric scripts
3. **Analyze Results**: Use `fine_grained_analysis.py` for detailed analysis

See `README-HOMELAB.md` for detailed usage instructions.
