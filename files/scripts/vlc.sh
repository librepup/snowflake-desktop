#!/usr/bin/env bash

vv() {
    if ! command -v cached-nix-shell &>/dev/null 2>/dev/null > /dev/null; then
        echo "Error: 'cached-nix-shell' not found in PATH."
        return 1
    fi

    if [[ -z $@ ]]; then
        echo "Error: Please specify Files or Directories to Play."
        return 1
    else
        cached-nix-shell \
            -p vlc \
            --run \
            "unshare -n --map-current-user vlc --loop --repeat $@" \
            --keep NIXPKGS_ALLOW_UNFREE \
            --keep NIXPKGS_ALLOW_INSECURE
    fi
}

cvv() {
    if ! command -v cached-nix-shell &>/dev/null 2>/dev/null > /dev/null; then
        echo "Error: 'cached-nix-shell' not found in PATH."
        return 1
    fi

    if [[ -z $@ ]]; then
        echo "Error: Please specify Files or Directories to Play."
        return 1
    else
        cached-nix-shell \
            -p vlc \
            --run \
            "unshare -n --map-current-user cvlc --avcodec-hw=none --loop --repeat $@" \
            --keep NIXPKGS_ALLOW_UNFREE \
            --keep NIXPKGS_ALLOW_INSECURE
    fi
}
