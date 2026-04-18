#!/usr/bin/env bash

_lash_setup_cmd() {
    # Clear Variables
    if [[ -n $cat9SetupComplete ]]; then
        unset cat9SetupComplete
    fi
    # Create Config Directory if Needed
    if [[ ! -d $HOME/.arcan/lash ]]; then
        mkdir -p $HOME/.arcan/lash
        echo "Created Arcan/Lash Config Directory"
    fi
    # Lash Configuration Hook
    if [[ -n $lashConfDir ]]; then
        unset lashConfDir
    fi
    local lashConfDir
    lashConfDir="$HOME/.arcan/lash"
    if [[ ! -d "$lashConfDir" ]]; then
        mkdir -p "$lashConfDir"
        echo "Created Lash Config Dir"
    fi
    # Arcan Binary Hook
    if [[ -n $arcanBinaryPath ]]; then
        unset arcanBinaryPath
    fi
    local arcanBinaryPath
    arcanBinaryPath=$(command -v arcan)
    if [[ -z "$arcanBinaryPath" ]]; then
        echo "Error: Arcan Not In \"\$PATH\", Aborting..."
        return 1
    fi
    if [[ -n $realArcanPath ]]; then
        unset realArcanPath
    fi
    local realArcanPath
    realArcanPath=$(realpath "$arcanBinaryPath")
    if [[ "$realArcanPath" == *nix/store* ]]; then
        if [[ -n $cat9StorePath ]]; then
            unset cat9StorePath
        fi
        local cat9StorePath
        cat9StorePath=$(echo "$realArcanPath" | sed 's|/bin/arcan|/share/arcan/appl/cat9|g')
        if [[ -f "$cat9StorePath/cat9.lua" ]]; then
            if ! diff -r "$lashConfDir" "$cat9StorePath" >/dev/null 2>&1; then
                cp -r "$cat9StorePath"/* "$lashConfDir/"
                echo "Synced Cat9 Config From Nix Store"
            fi
            if [[ ! -f "$lashConfDir/default.lua" ]]; then
                cp "$lashConfDir/cat9.lua" "$lashConfDir/default.lua"
                echo "Copied Cat9 Lua to Default Lua"
            fi
        else
            echo "Error: Cat9 Source Files Not Found In Nix Store, Aborting..."
            return 1
        fi
    else
        echo "Error: Arcan Is Not a Nix Store Binary, Aborting..."
        return 1
    fi
    export cat9SetupComplete=1
}

_lash_cmd() {
    if [[ "$cat9SetupComplete" != 1 ]]; then
        echo "Error: Setup Was Not Completed, Aborting..."
        return 1
    fi
    if command -v arcan_db >/dev/null; then
        arcan_db add_appl_kv console font_size 14 >/dev/null 2>&1
    fi
    if command -v devour >/dev/null; then
        devour arcan console lash
    else
        arcan console lash
    fi
}

_lash_kill_cmd() {
    if pgrep -f arcan >/dev/null; then
        pkill -f arcan
        echo "Successfully Killed Arcan Console"
        return 0
    else
        echo "Error: Arcan Not Running"
        return 1
    fi
}

_lash_main_hook() {
    if [[ "$cat9SetupComplete" != 1 ]]; then
        _lash_setup_cmd || return 1
    fi
    _lash_cmd
}

# Set Aliases
alias _lash="_lash_main_hook"
alias _lash_kill="_lash_kill_cmd"
