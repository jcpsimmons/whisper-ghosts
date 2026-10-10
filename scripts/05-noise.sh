#!/usr/bin/env bash
# Step 5 (optional): it isn't only digital silence. Quiet background noise does it too.
source "$(dirname "$0")/_common.sh"

banner "Making 30-second noise clips"
ffmpeg -hide_banner -loglevel error -y -f lavfi -i "anoisesrc=d=30:c=brown:r=16000:a=0.05" "$AUDIO/brown-noise.wav"
ffmpeg -hide_banner -loglevel error -y -f lavfi -i "anoisesrc=d=30:c=pink:r=16000:a=0.02" "$AUDIO/pink-noise.wav"
ffmpeg -hide_banner -loglevel error -y -f lavfi -i "sine=f=60:r=16000:d=30" -af volume=0.05 "$AUDIO/hum-60hz.wav"
note "brown noise (like a fan), quiet pink noise (like room tone), 60 Hz electrical hum"

banner "Noise, language: English"
for clip in brown-noise pink-noise hum-60hz; do
  show "$clip" "$(transcribe "$AUDIO/$clip.wav" en "noise-$clip")"
done
