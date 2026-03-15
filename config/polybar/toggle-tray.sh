#!/bin/sh
TRAY_CONFIG=~/.config/polybar/tray.ini
PID=$(pgrep -f "polybar tray-bar --config=$TRAY_CONFIG")

if [ -n "$PID" ]; then
  kill -9 $PID
else
  polybar tray-bar --config=$TRAY_CONFIG &
fi
