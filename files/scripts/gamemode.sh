#!/usr/bin/env bash

gamemode-status() {
    notify-send "Gamemode Status" "`gamemoded --status=$(xprop | grep _NET_WM_PID | awk '{print $3}' | grep -o '[0-9]*')`"
}

gamemode-toggle() {
    notify-send "Gamemode Status" "`gamemoded --request=$(xprop | grep _NET_WM_PID | awk '{print $3}' | grep -o '[0-9]*')`"
}
