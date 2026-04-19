#!/usr/bin/env bash

yad --notification \
    --item-separator="_" \
    --no-middle \
    --command="true" \
    --image="$HOME/Pictures/Icons/waypaper.svg" \
    --text="WayPaper" \
    --menu="Open_waypaper||Restore Wallpaper_waypaper --restore||Quit_pkill yad" &
