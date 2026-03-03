#!/usr/bin/env sh

STATE_FILE="$HOME/.cache/polybar-date-toggle"
[ ! -f "$STATE_FILE" ] && echo "normal" > "$STATE_FILE"
MODE="$1"

case "$MODE" in
    switch)
        if [ "$(cat "$STATE_FILE")" = "normal" ]; then
            echo "alt" > "$STATE_FILE"
        elif [ "$(cat "$STATE_FILE")" = "alt" ]; then
            echo "short" > "$STATE_FILE"
        else
            echo "normal" > "$STATE_FILE"
        fi
        polybar-msg hook date 1
        ;;
    reset)
        STATE=$(cat "$STATE_FILE")
        rm $STATE_FILE && touch $STATE_FILE
        echo "normal" > "$STATE_FILE"
        echo "%{F#FFBF2D}󰭨 %{F#81D28B}$(date +'%a %d.%m') %{F#FFBF2D} %{F#81D28B}$(date +'%H:%M')"
        ;;
    output|*)
        STATE=$(cat "$STATE_FILE")
        if [ "$STATE" = "normal" ]; then
            echo "%{F#FFBF2D}󰭨 %{F#81D28B}$(date +'%a %d.%m') %{F#FFBF2D} %{F#81D28B}$(date +'%H:%M')"
        elif [ "$STATE" = "alt" ]; then
            echo "%{F#FFBF2D} %{F#81D28B}$(date +'%H:%M')"
        else
            seddedDate=$(date +'%A, %d. %B' | sed 's/ä/a/g;s/ö/o/g;s/ü/u/g;s/Ä/a/g;s/Ü/u/g;s/Ö/o/g')
            echo "%{F#FFBF2D}󰭨 %{F#81D28B}${seddedDate} %{F#FFBF2D} %{F#81D28B}$(date +'%H:%M:%S')"
        fi
        ;;
esac
