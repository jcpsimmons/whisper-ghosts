#!/usr/bin/env bash
# Step 4: the same 30 seconds of silence, labeled as a different language each time.
# Pass your own list of language codes to change it:  ./scripts/04-roll-call.sh es it ko
source "$(dirname "$0")/_common.sh"
need_silence

langs=("$@")
[ ${#langs[@]} -eq 0 ] && langs=(en ar pt cs tr fr zh ko ja ru de es)

banner "Roll call: 30 seconds of silence in ${#langs[@]} languages"
for lang in "${langs[@]}"; do
  show "$lang" "$(transcribe "$SILENCE" "$lang" "rollcall-$lang")"
done
note "Every line above came out of a file with no sound in it."
