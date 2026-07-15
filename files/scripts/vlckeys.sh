#!/usr/bin/env bash

set -euo pipefail

key="$1"
wid="$(xdotool getactivewindow)"
wm_class="$(xprop -id "$wid" WM_CLASS 2>/dev/null | awk -F'= ' '/WM_CLASS/ {print $2}' | tr -d '"')"

if [[ "$key" == "n" ]]; then
    orig="9"
else
    orig="8"
fi

if [[ "$wm_class" == vlc,* || "$wm_class" == VLC,* || "$wm_class" == vlc || "$wm_class" == VLC ]]; then
    xdotool key --window "$wid" "$key"
else
    xdotool click --window "$wid" "$orig"
fi
