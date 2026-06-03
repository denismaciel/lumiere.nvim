#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
title="lumiere-snapshot"
snapshot="$repo/lumiere_snapshot.png"
comparison="$repo/lumiere_comparison.png"

ghostty \
  --title="$title" \
  --font-size=16 \
  --working-directory="$repo" \
  -e "$repo/scripts/open-snapshot-nvim.sh" &

ghostty_pid=$!

window_id=""
for _ in $(seq 1 80); do
  window_id="$(niri msg -j windows \
    | jq -r --arg title "$title" '.[] | select(.title == $title) | .id' \
    | head -n 1)"
  if [[ -n "$window_id" ]]; then
    break
  fi
  sleep 0.1
done

if [[ -z "$window_id" ]]; then
  kill "$ghostty_pid" 2>/dev/null || true
  echo "could not find $title window" >&2
  exit 1
fi

niri msg action focus-window --id "$window_id" >/dev/null
niri msg action maximize-column >/dev/null || true
sleep 0.5
niri msg action screenshot-window --id "$window_id" --path "$snapshot" >/dev/null
niri msg action close-window --id "$window_id" >/dev/null || true

nix shell nixpkgs#imagemagick -c sh -lc "
  magick '$repo/lumiere_dim_inactive.png' -resize x1400 /tmp/lumiere_original_resized.png
  magick '$snapshot' -resize x1400 /tmp/lumiere_snapshot_resized.png
  magick /tmp/lumiere_original_resized.png /tmp/lumiere_snapshot_resized.png +append '$comparison'
"

echo "$snapshot"
echo "$comparison"
