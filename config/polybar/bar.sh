#!/bin/sh

if pgrep -x polybar > /dev/null; then
  pkill polybar
fi

if type "xrandr" > /dev/null; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --config=~/.config/polybar/config.ini --reload main &
  done
else
  polybar --config=~/.config/polybar/config.ini --reload main &
fi
