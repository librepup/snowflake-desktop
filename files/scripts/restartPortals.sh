#!/usr/bin/env bash

restart-portals() {
    echo "Restarting XDG Portals..."
    systemctl --user stop xdg-desktop-portal xdg-desktop-portal-gtk
    dbus-update-activation-environment --systemd DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP=XMonad
    systemctl --user start xdg-desktop-portal
    echo "Successfully Restarted XDG Portal Services"
}
