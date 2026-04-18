#!/usr/bin/env bash

_random_func() {
    if [[ -n $_custom_rand ]]; then
        unset _custom_rand
    fi
    export _custom_rand=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12)
}

_diff_xmonad_files() {
    mkdir -p /tmp/"${_custom_rand}"-xmonadConfigurationBackup
    if [[ -n $_backup_dir ]]; then
        unset _backup_dir
    fi
    local _backup_dir
    _backup_dir="${_custom_rand}-xmonadConfigurationBackup"
    if [[ ! -f /tmp/xmonadsync.log ]]; then
        touch /tmp/xmonadsync.log
    fi
    if [[ -n $_cur_date ]]; then
        unset _cur_date
    fi
    local _cur_date
    _cur_date=$(date +"%H:%M:%S - %A, %d %B")
    echo -e "${_cur_date}:\n  ${_backup_dir}" >> /tmp/xmonadsync.log
    unset _cur_date
    if [[ -n backedUpXMonadHS ]]; then
        unset backedUpXMonadHS
    fi
    if [[ -n backedUpXMonadLib ]]; then
        unset backedUpXMonadLib
    fi
    if ! diff -bur "$HOME/.xmonad/lib" /etc/nixos/files/config/xmonad/lib > /dev/null 2>/dev/null && ! diff "$HOME/.xmonad/xmonad.hs" /etc/nixos/files/config/xmonad/xmonad.hs > /dev/null 2>/dev/null; then
        if [[ -f $HOME/.xmonad/xmonad.hs ]]; then
            mv $HOME/.xmonad/xmonad.hs /tmp/"${_custom_rand}"-xmonadConfigurationBackup/xmonad.hs
            local backedUpXMonadHS
            backedUpXMonadHS=1
        else
            local backedUpXMonadHS
            backedUpXMonadHS=0
        fi
        if [[ -d $HOME/.xmonad/lib ]]; then
            mv $HOME/.xmonad/lib /tmp/"${_custom_rand}"-xmonadConfigurationBackup/lib
            local backedUpXMonadLib
            backedUpXMonadLib=1
        else
            local backedUpXMonadLib
            backedUpXMonadLib=0
        fi
        dunstctl close
        if [[ "$backedUpXMonadHS" == 1 ]]; then
            notify-send -i $HOME/Pictures/xmonad_logo.png 'Notice' 'Backed up "xmonad.hs" File to "/tmp/${_custom_rand}-xmonadConfigurationBackup/xmonad.hs".'
        fi
        if [[ "$backedUpXMonadLib" == 1 ]]; then
            notify-send -i $HOME/Pictures/xmonad_logo.png 'Notice' 'Backed up "lib" Directory to "/tmp/${_custom_rand}-xmonadConfigurationBackup/lib".'
        fi
        if [[ -d /etc/nixos/files/config/xmonad ]]; then
            cp -r /etc/nixos/files/config/xmonad/* $HOME/.xmonad/
            doas chown -R puppy:users $HOME/.xmonad/* > /dev/null 2>/dev/null
        else
            notify-send -i $HOME/Pictures/error.png 'Error' 'Could Not Find XMonad Configuration Directory'
            return 1
        fi
        notify-send -i $HOME/Pictures/yes.png 'Synchronized' 'Successfully Synchronized XMonad Configuration.'
        return 0
    else
        notify-send -i $HOME/Pictures/yes.png 'Synchronized' 'XMonad Configuration already Synchronized.'
        return 0
    fi
}

_open_dir_func() {
    if [[ -n $_open_quest ]]; then
        unset _open_quest
    fi
    local _open_quest
    _open_quest=$(echo -e "Open\nIgnore" | dmenu -nb '#0A0A05' -nf '#D4921A' -sf '#000000' -sb '#D4921A' -fn 'DejaVu Sans Mono:size=18' -p "Open '${_custom_rand}-xmonadConfigurationBackup'?")
    if [[ "$_open_quest" == *Open* ]]; then
        thunar /tmp/"${_custom_rand}-xmonadConfigurationBackup" &
    fi
}
_meta_func() {
    _random_func
    _diff_xmonad_files
    _open_dir_func
    unset _custom_rand
    unset _open_quest
}

alias xmonadsync="_meta_func"
