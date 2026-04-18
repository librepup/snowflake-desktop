#!/usr/bin/env bash
# Run Emacs Desktop-Aware

ed() {
    if [[ "$XDG_SESSION_TYPE" == "wayland" ]] || [[ "$XDG_CURRENT_DESKTOP" == "naitre" ]]; then
	nixmacs-wayland -nw "$@"
    elif [[ "$XDG_SESSION_TYPE" == "x11" ]] || [[ "$XDG_SESSION_TYPE" == "xorg" ]]; then
	nixmacs -nw "$@"
    else
	nixmacs -nw "$@"
    fi
}
