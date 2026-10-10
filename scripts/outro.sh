#!/usr/bin/env bash
# Outro: let the computer read the sign-off the ghosts keep writing.
#
#   ./scripts/outro.sh                     speak it
#   ./scripts/outro.sh --save              save out/outro.aiff and out/outro.wav for editing (silent)
#   VOICE=Whisper ./scripts/outro.sh       macOS really does ship a voice named Whisper
#   ./scripts/outro.sh "Any other line"    say something else
source "$(dirname "$0")/_common.sh"

VOICE="${VOICE:-Fred}"
RATE="${RATE:-165}"
save=0
if [ "${1:-}" = "--save" ]; then save=1; shift; fi
LINE="${1:-Thank you for watching. Please like and subscribe.}"

if command -v say >/dev/null 2>&1; then
  if [ "$save" = 1 ]; then
    say -v "$VOICE" -r "$RATE" -o "$OUT/outro.aiff" "$LINE"
    ffmpeg -hide_banner -loglevel error -y -i "$OUT/outro.aiff" -ar 48000 "$OUT/outro.wav"
    note "Saved $OUT/outro.aiff and $OUT/outro.wav"
  else
    say -v "$VOICE" -r "$RATE" "$LINE"
  fi
elif command -v espeak >/dev/null 2>&1; then
  espeak "$LINE"
else
  echo "$LINE"
  note "No text-to-speech found. 'say' ships with macOS; on Linux, install espeak."
fi
