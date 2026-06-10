#!/usr/bin/env bash

set -euo pipefail

# Available engines
ENGINES=(
  "xkb:us:colemak:eng"
  "typing-booster"
)

CURRENT="$(ibus engine 2>/dev/null || true)"

# Build rofi list with current indicator
MENU_INPUT="$(
  for e in "${ENGINES[@]}"; do
    if [[ "$e" == "$CURRENT" ]]; then
      if [[ "$e" == "xkb:us:colemak:eng" ]]; then
        e="US Colemak"
      elif [[ "$e" == "typing-booster" ]]; then
        e="TypingBooster"
      else
        true
      fi
      printf "%s (current)\n" "$e"
    else
      if [[ "$e" == "xkb:us:colemak:eng" ]]; then
        e="US Colemak"
      elif [[ "$e" == "typing-booster" ]]; then
        e="TypingBooster"
      else
        true
      fi
      printf "%s\n" "$e"
    fi
  done
)"

CHOICE="$(
  echo "$MENU_INPUT" | rofi \
    -dmenu \
    -i \
    -p "IBus Engine: $CURRENT" \
    -theme-str 'listview { columns: 1; } element { padding: 6px; }'
)"

# Exit silently if cancelled
[[ -z "${CHOICE:-}" ]] && exit 0

# Strip "(current)" if user picked it
CHOICE="${CHOICE% (Current)}"

# No change needed
if [[ "$CHOICE" == "$CURRENT" ]]; then
  notify-send "IBus" "Already using: $CHOICE"
  exit 0
fi

# Validate selection
case "$CHOICE" in
  "xkb:us:colemak:eng"|"typing-booster")
    ibus engine "$CHOICE"
    notify-send "IBus Engine Changed" "$CHOICE"
    ;;
  *)
    notify-send "IBus" "Invalid selection: $CHOICE"
    exit 1
    ;;
esac
