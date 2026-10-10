#!/usr/bin/env bash
# One-time setup: checks for ffmpeg and installs Whisper into a local .venv folder.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "ffmpeg is missing. Install it first:"
  echo "  macOS:          brew install ffmpeg"
  echo "  Ubuntu/Debian:  sudo apt install ffmpeg"
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is missing. Install Python 3.9 or newer first."
  exit 1
fi

echo "Creating .venv and installing OpenAI's whisper (this downloads PyTorch, a few minutes)..."
python3 -m venv .venv
.venv/bin/pip install --quiet --upgrade pip
.venv/bin/pip install --quiet openai-whisper

if [ "$(uname -s)" = "Darwin" ] && [ "$(uname -m)" = "arm64" ]; then
  echo "Apple Silicon Mac detected. Also installing mlx-whisper (faster)..."
  .venv/bin/pip install --quiet mlx-whisper
fi

echo
echo "Done. Next:"
echo "  ./scripts/run-all.sh"
echo "The first run downloads the turbo model (about 1.5 GB)."
