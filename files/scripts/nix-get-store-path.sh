#!/usr/bin/env bash

nix-get-store-path() {
    if [ $# -eq 0 ]; then
        echo "Usage: nix-get-store-path <application>"
        return 1
    fi
    readlink -f "$(which "$@")"
}

ngsp() {
    if [ $# -eq 0 ]; then
        echo "Usage: ngsp <application>"
        return 1
    fi
    readlink -f "$(which "$@")"
}
