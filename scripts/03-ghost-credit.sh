#!/usr/bin/env bash
# Step 3: the same silence, labeled Arabic.
# First with OpenAI's default settings, then with greedy decoding, twice, to show
# the greedy result comes back identical every time.
source "$(dirname "$0")/_common.sh"
need_silence

if [ "$BACKEND" = "openai" ]; then
  banner "Silence, language: Arabic, default settings (beam search)"
  show "ar" "$(transcribe "$SILENCE" ar silence-ar-default default)"
fi

banner "Silence, language: Arabic, greedy decoding"
show "run 1" "$(transcribe "$SILENCE" ar silence-ar-run1)"
show "run 2" "$(transcribe "$SILENCE" ar silence-ar-run2)"

if cmp -s "$OUT/silence-ar-run1/silence.txt" "$OUT/silence-ar-run2/silence.txt"; then
  note "The two greedy runs are identical, byte for byte."
else
  note "The two greedy runs differ."
fi
note "Paste the Arabic into any translator to read it."
