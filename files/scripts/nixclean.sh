#!/usr/bin/env bash
# Nix Clean

clean() {
    echo "Garbage Collecting \"/nix/store\"..."
    doas nix-store --gc > /dev/null
    echo "Collecting Global Garbage..."
    doas nix-collect-garbage -d > /dev/null
    echo "Optimizing Store..."
    nix store optimise > /dev/null
    echo "Done."
}
