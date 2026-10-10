#!/usr/bin/env bash
# Shared settings and helpers. Every numbered script sources this file.
#
# Override any setting from the command line, for example:
#   BACKEND=mlx ./scripts/03-ghost-credit.sh
#   MODEL=small ./scripts/04-roll-call.sh

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AUDIO="$ROOT/audio"
OUT="$ROOT/out"
mkdir -p "$AUDIO" "$OUT"

# openai = OpenAI's official whisper command line tool (Mac, Linux, Windows via WSL)
# mlx    = mlx-whisper, a fast port for Apple Silicon Macs
BACKEND="${BACKEND:-openai}"

# turbo is large-v3-turbo, the default model in OpenAI's tool.
MODEL="${MODEL:-turbo}"

SILENCE="$AUDIO/silence.wav"

bold=$'\033[1m'; dim=$'\033[2m'; green=$'\033[32m'; reset=$'\033[0m'
banner() { printf '\n%s== %s ==%s\n' "$bold" "$*" "$reset"; }
note()   { printf '%s%s%s\n' "$dim" "$*" "$reset"; }
show()   { printf '  %s%-12s%s %s%s%s\n' "$dim" "$1" "$reset" "$green$bold" "$2" "$reset"; }

# Use the copy in .venv if setup.sh made one, otherwise whatever is on your PATH.
find_bin() {
  if [ -x "$ROOT/.venv/bin/$1" ]; then echo "$ROOT/.venv/bin/$1"
  elif command -v "$1" >/dev/null 2>&1; then command -v "$1"
  else echo "Missing '$1'. Run ./scripts/setup.sh first." >&2; exit 1
  fi
}

need_silence() {
  [ -f "$SILENCE" ] || "$ROOT/scripts/01-make-silence.sh" >/dev/null
}

# transcribe <audio file> <language code> <run name> [greedy|default]
#   greedy  = always pick the single most likely next word. This is the setting
#             that makes the subtitle credits show up.
#   default = OpenAI's command line defaults (beam search with 5 beams).
# Prints the transcript as one line and saves it under out/<run name>/.
transcribe() {
  local file="$1" lang="$2" name="$3" mode="${4:-greedy}"
  local dir="$OUT/$name" base
  base="$(basename "${file%.*}")"
  rm -rf "$dir"; mkdir -p "$dir"

  if [ "$BACKEND" = "mlx" ]; then
    local repo="mlx-community/whisper-large-v3-turbo"
    [ "$MODEL" != "turbo" ] && repo="$MODEL"
    # mlx-whisper has no beam search, so it always decodes greedily.
    "$(find_bin mlx_whisper)" "$file" --model "$repo" --language "$lang" \
      --output-format txt --output-dir "$dir" --verbose False >/dev/null 2>"$dir/log.txt"
  else
    local beam=()
    [ "$mode" = "greedy" ] && beam=(--beam_size None)
    "$(find_bin whisper)" "$file" --model "$MODEL" --language "$lang" \
      ${beam[@]+"${beam[@]}"} --fp16 False \
      --output_format txt --output_dir "$dir" --verbose False >/dev/null 2>"$dir/log.txt"
  fi

  if [ ! -f "$dir/$base.txt" ]; then
    echo "Transcription failed. Details: $dir/log.txt" >&2; exit 1
  fi
  local text
  text="$(tr '\n' ' ' < "$dir/$base.txt" | sed -e 's/^ *//' -e 's/ *$//')"
  echo "${text:-(nothing)}"
}
