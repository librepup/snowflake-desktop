#!/usr/bin/env bash

__backupNixOSConfigFunc() {
    if [[ -d /etc/nixos ]] && command -v rsync &>/dev/null > /dev/null 2>/dev/null; then
        if [[ -n $__backupNixOSConfigFunc__curDateVar ]]; then
            unset __backupNixOSConfigFunc__curDateVar
        fi
        if command -v nix-shell &>/dev/null > /dev/null 2>/dev/null; then
            export __backupNixOSConfigFunc__curDateVar=$(nix-shell -p coreutils --run "sh -c 'date +%Hh%Mm%Ss.AT.%dd%mm%yy'")
        elif command -v date &>/dev/null > /dev/null 2>/dev/null; then
            export __backupNixOSConfigFunc__curDateVar=$(sh -c 'date +%Hh%Mm%Ss.AT.%dd%mm%yy')
            if [[ -z $__backupNixOSConfigFunc__curDateVar ]]; then
                echo "Error: Var Empty"
                return 1
            fi
        else
            echo "Error: Date Unavailable"
            return 1
        fi
        mkdir -p "/tmp/${__backupNixOSConfigFunc__curDateVar}"
        rsync -av --progress /etc/nixos/* /tmp/${__backupNixOSConfigFunc__curDateVar} --exclude .git
        echo "Complete: Copied '/etc/nixos' to '/tmp/${__backupNixOSConfigFunc__curDateVar}'"
        return 0
    else
        echo "Error: No NixOS Config Directory, or RSync Unavailable"
        return 1
    fi
}

backup-nixos-config() {
    __backupNixOSConfigFunc
}

nix-backup-config-directory() {
    __backupNixOSConfigFunc
}
