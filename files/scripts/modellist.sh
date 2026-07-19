#!/usr/bin/env bash

cached-nix-shell \
    --run "figlet -f slant 'Models'" \
    --keep NIXPKGS_ALLOW_UNFREE \
    --keep NIXPKGS_ALLOW_INSECURE \
    -p figlet 2>/dev/null

ollama ls | awk 'NR!=1{print $1}'
