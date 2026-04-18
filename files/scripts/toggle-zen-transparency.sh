#!/usr/bin/env bash

toggleZenTransparency() {
    arg=$1
    if [ $# -eq 0 ]; then
        echo -e "Toggle Zen Transparency: USAGE
Options
  On  - Enable Transparency
  Off - Disable Transparency
"
        return 1
    fi
    local winPid
    winPid=$(xprop | grep "PID" | awk '{print $3}')
    local winId
    winId=$(wmctrl -p -l | grep "${winPid}" | awk '{print $1}')
    case $arg in
        *On*)
            xdotool set_window --classname "zen" "$winId" set_window --class "Emacs" "$winId"
            return 0
            ;;
        *Off*)
            xdotool set_window --classname "Emacs" "$winId" set_window --class "zen" "$winId"
            return 0
            ;;
    esac
}
