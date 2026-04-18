#!/usr/bin/env bash

# Bar Files
doas rm -f /etc/nixos/files/config/polybar/*
doas cp "$(echo "$(realpath $(which jonabar-gigi) | sed 's|/bin/.*|/etc|g')")"/* /etc/nixos/files/config/polybar/
# Modules
rm -rf $HOME/Documents/Projects/snowflake-desktop/modules
doas cp -r /etc/nixos/modules $HOME/Documents/Projects/snowflake-desktop/modules
echo "Copied Modules"
# Files
rm -rf $HOME/Documents/Projects/snowflake-desktop/files
doas cp -r /etc/nixos/files $HOME/Documents/Projects/snowflake-desktop/files
echo "Copied Files"
# Flake.nix
rm $HOME/Documents/Projects/snowflake-desktop/flake.nix
doas cp /etc/nixos/flake.nix $HOME/Documents/Projects/snowflake-desktop/flake.nix
echo "Copied flake.nix"
# Flake.lock
rm $HOME/Documents/Projects/snowflake-desktop/flake.lock
doas cp /etc/nixos/flake.lock $HOME/Documents/Projects/snowflake-desktop/flake.lock
echo "Copied flake.lock"
# Hardware Configuration
rm $HOME/Documents/Projects/snowflake-desktop/hardware-configuration.nix
doas cp /etc/nixos/hardware-configuration.nix $HOME/Documents/Projects/snowflake-desktop/hardware-configuration.nix
echo "Copied hardware-configuration.nix"
# Sync Script
rm $HOME/Documents/Projects/snowflake-desktop/sync.sh
doas cp /etc/nixos/sync.sh $HOME/Documents/Projects/snowflake-desktop/sync.sh
echo "Copied sync.sh"
# Change Ownership
doas chown -R puppy:users $HOME/Documents/Projects/snowflake-desktop/*
echo "Changed Ownership"

# Verify Integrity
if [[ -n $checkVar ]]; then
    unset checkVar
fi
checkVar=0
doas diff -bur /etc/nixos/modules $HOME/Documents/Projects/snowflake-desktop/modules > /dev/null 2>&1 && checkVar=$((checkVar + 1)) && echo "Match Found: modules" || { echo "Modules Mismatch" && return 1; }
doas diff -bur /etc/nixos/files $HOME/Documents/Projects/snowflake-desktop/files > /dev/null 2>&1 && checkVar=$((checkVar + 1)) && echo "Match Found: files" || { echo "Files Mismatch" && return 1; }
doas diff /etc/nixos/flake.nix $HOME/Documents/Projects/snowflake-desktop/flake.nix > /dev/null 2>&1 && checkVar=$((checkVar + 1)) && echo "Match Found: flake.nix" || { echo "Flake Nix Mismatch" && return 1; }
doas diff /etc/nixos/flake.lock $HOME/Documents/Projects/snowflake-desktop/flake.lock > /dev/null 2>&1 && checkVar=$((checkVar + 1)) && echo "Match Found: flake.lock" || { echo "Flake Lock Mismatch" && return 1; }
doas diff /etc/nixos/hardware-configuration.nix $HOME/Documents/Projects/snowflake-desktop/hardware-configuration.nix > /dev/null 2>&1 && checkVar=$((checkVar + 1)) && echo "Match Found: hardware-configuration.nix" || { echo "Hardware Config Mismatch" && return 1; }

if [[ "$checkVar" != 5 ]]; then
    echo -e "\nError: File Mismatch"
else
    echo -e "\nAll Files Match"
fi

unset checkVar
