#!/usr/bin/env bash

play() {
    if [ $# -eq 0 ]; then
        echo "Usage: play <file-or-dir> ..."
        return 1
    fi
    local all_images=true
    for arg in "$@"; do
        if [ -d "$arg" ]; then
            all_images=false
            break
        elif [ -f "$arg" ]; then
            if [[ ! $(file --mime-type -b "$arg") == image/* ]]; then
                all_images=false
                break
            fi
        else
            all_images=false
            break
        fi
    done
    if [ "$all_images" = true ]; then
        devour mpv --really-quiet "$@"
    else
        devour mpv --really-quiet --loop-file=no --loop-playlist=inf --image-display-duration=1 "$@"
    fi
}
