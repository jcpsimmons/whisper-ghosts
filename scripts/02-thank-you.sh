#!/usr/bin/env bash
# Step 2: give Whisper the silence and tell it the audio is English.
source "$(dirname "$0")/_common.sh"
need_silence

banner "30 seconds of silence, language: English"
show "en" "$(transcribe "$SILENCE" en silence-en)"
