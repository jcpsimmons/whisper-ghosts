#!/usr/bin/env bash
# Step 1: make 30 seconds of pure digital silence and prove it is silent.
source "$(dirname "$0")/_common.sh"

banner "Making 30 seconds of digital silence"
ffmpeg -hide_banner -loglevel error -y \
  -f lavfi -i anullsrc=r=16000:cl=mono -t 30 -c:a pcm_s16le "$SILENCE"
note "Saved $SILENCE"

banner "Is it really silent?"
ffmpeg -hide_banner -i "$SILENCE" -af volumedetect -f null - 2>&1 \
  | grep -E 'mean_volume|max_volume' | sed 's/^.*\] /  /'
note "-91 dB is the floor for 16-bit audio. Every sample in this file is zero."
