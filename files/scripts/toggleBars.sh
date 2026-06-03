#!/usr/bin/env bash

# Clean-Up Vars
unset dp1BarWinId
unset hdmi0BarWinId
unset dp1BarPid
unset hdmi0BarPid

# Get Bar IDs and PIDs
dp1BarWinId=$(xwininfo -root -children | grep "polybar" | grep "DP-0" | awk '{print $1}')
dp1BarPid=$(xprop -id "$dp1BarWinId" _NET_WM_PID | sed 's/_NET_WM_PID(CARDINAL) = //')

hdmi0BarWinId=$(xwininfo -root -children | grep "polybar" | grep "HDMI-0" | awk '{print $1}')
hdmi0BarPid=$(xprop -id "$hdmi0BarWinId" _NET_WM_PID | sed 's/_NET_WM_PID(CARDINAL) = //')

toggleBarFunc() {
    arg=$1
    if [[ -z $arg ]] || [[ $arg == "" ]]; then
        unset arg
        export arg="FallbackIndex"
    fi
    if [[ $arg == "0" ]] || [[ $arg == "FallbackIndex" ]]; then
        polybar-msg -p "$dp1BarPid" cmd toggle 2>/dev/null > /dev/null
        unset arg
        return 0
    elif [[ $arg == "1" ]]; then
        polybar-msg -p "$hdmi0BarPid" cmd toggle 2>/dev/null > /dev/null
        unset arg
        return 0
    else
        notify-send 'Error' 'Bar Number out of Range.'
        return 1
    fi
}

toggleBarFunc $1
