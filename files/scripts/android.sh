#!/usr/bin/env bash

android-start() {
    doas systemctl start waydroid-container
    weston --shell=kiosk-shell.so --width=1920 --height=1080 &
    sleep 2 && WAYLAND_DISPLAY=wayland-1 waydroid show-full-ui
}

android-stop() {
    pkill weston
    waydroid session stop
    doas systemctl stop waydroid-container
}

android-restart() {
    pkill weston
    waydroid session stop
    doas systemctl restart waydroid-container
    weston --shell=kiosk-shell.so --width=1920 --height=1080 &
    sleep 2 && WAYLAND_DISPLAY=wayland-1 waydroid show-full-ui
}
