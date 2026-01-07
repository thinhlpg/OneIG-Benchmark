# OneIG-Bench Homelab Setup

This is the OneIG-Bench benchmark setup for the homelab environment (CUDA 12.9, Python 3.12.12).

## Quick Start

```bash
# 1. Setup environment and dependencies
bash setup.sh

# 2. Generate images (modify text2image.py with your model inference)
source .venv/bin/activate
python text2image.py

# 3. Run evaluation
bash run.sh
```

## Environment

- **OS**: CachyOS (Linux Native)
- **CUDA**: 12.9
- **Python**: 3.12.12
- **Package Manager**: uv
- **PyTorch**: 2.6.0 (with CUDA 12.9 support)

## Directory Structure

```
oneig-benchmark/
├── images/                    # Generated images (created by setup.sh)
│   ├── anime/
│   ├── human/
│   ├── object/
│   ├── text/
│   ├── reasoning/
│   └── multilingualism/
├── scripts/
│   └── style/
│       └── models/            # CSD and CLIP models go here
├── models/                    # DreamSim and DINO models go here
│   ├── dreamsim_ensemble_checkpoint/
│   ├── dino_vitbase16_pretrain.pth
│   └── dino/                  # DINO repository
├── results/                   # Evaluation results (created during evaluation)
├── .venv/                     # Virtual environment
├── setup.sh                   # Setup script
└── run.sh                     # Run script
```

## Required Models

After running `setup.sh`, you need to manually download:

1. **CSD Model** (for style evaluation):
   - Download from: https://drive.google.com/file/d/1FX0xs8p-C7Ob-h5Y4cUhTeOepHzXv_46/view?usp=sharing
   - Save as: `scripts/style/models/csd_model.pth`

2. **DreamSim Model** (for diversity metrics):
   - Download from: https://github.com/ssundaram21/dreamsim/releases/download/v0.2.0-checkpoints/dreamsim_ensemble_checkpoint.zip
   - Extract to: `models/dreamsim_ensemble_checkpoint/`

3. **OneIG-StyleEncoder** (optional, for style evaluation):
   - Download from: https://huggingface.co/xingpng/OneIG-StyleEncoder
   - Save to: `scripts/style/models/`

## Image Generation

Modify `text2image.py` to add your model's inference function. The script expects:

- 4 images per prompt (with different seeds)
- Images saved in category subfolders (anime, human, object, text, reasoning, multilingualism)
- Filenames matching prompt IDs from `OneIG-Bench.csv` or `OneIG-Bench-ZH.csv`

## Evaluation

### Run All Metrics

```bash
bash run.sh
```

### Run Individual Metrics

```bash
# Alignment score
bash run_alignment.sh

# Text rendering score
bash run_text.sh

# Diversity score
bash run_diversity.sh

# Style score
bash run_style.sh

# Reasoning score
bash run_reasoning.sh
```

### Configuration

Edit the run scripts to configure:

- `MODE`: `EN` or `ZH` (English or Chinese benchmark)
- `IMAGE_DIR`: Directory containing generated images
- `MODEL_NAMES`: List of model names to evaluate
- `IMAGE_GRID`: Number of images per prompt (1 = 1 image, 2 = 4 images)
- `class_items`: Categories to evaluate

## Fine-Grained Analysis

After running evaluation, use `fine_grained_analysis.py` for detailed analysis:

1. Copy all CSV result files into a subfolder named after your model in `results/`
2. Edit `fine_grained_analysis.py` to set:
   - `MODE`: `EN` or `ZH`
   - `RESULT_DIR`: Path to results directory
   - `KEYS`: Metrics to analyze

## Notes

- **CUDA Compatibility**: PyTorch 2.6.0 is installed with CUDA 12.4 wheels (compatible with CUDA 12.9)
- **Flash Attention**: May need manual installation if pre-built wheel fails
- **Model Downloads**: Some models require manual download due to Google Drive links
- **Image Format**: Scripts expect `.webp` format by default, but can be modified

## Troubleshooting

### Flash Attention Installation Fails

```bash
source .venv/bin/activate
git clone https://github.com/Dao-AILab/flash-attention.git
cd flash-attention
pip install .
cd ..
```

### CUDA Out of Memory

- Reduce `IMAGE_GRID` in run scripts (fewer images per prompt)
- Use smaller batch sizes in evaluation scripts
- Generate images in batches

### Model Not Found Errors

- Verify all required models are downloaded to correct locations
- Check file paths in evaluation scripts
- Ensure model files have correct names

## References

- **Original Repository**: https://github.com/OneIG-Bench/OneIG-Benchmark
- **Project Page**: https://oneig-bench.github.io/
- **HuggingFace Dataset**: https://huggingface.co/datasets/OneIG-Bench/OneIG-Bench
- **Paper**: https://arxiv.org/abs/2506.07977
