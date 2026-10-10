#!/usr/bin/env bash
# Run every step in order.
set -euo pipefail
dir="$(dirname "$0")"
"$dir/01-make-silence.sh"
"$dir/02-thank-you.sh"
"$dir/03-ghost-credit.sh"
"$dir/04-roll-call.sh"
"$dir/05-noise.sh"
"$dir/outro.sh"
