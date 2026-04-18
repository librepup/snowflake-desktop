#!/usr/bin/env bash

eww-start() {
    eww --config $HOME/.config/eww daemon
    eww --config $HOME/.config/eww open clock
    eww --config $HOME/.config/eww open filian
    xdo lower -n eww
}

eww-stop() {
    eww --config $HOME/.config/eww kill
    pkill eww
}
