#!/usr/bin/env bash

_avtx_get_wineprefix() {
    if [[ -n $WINEPREFIX ]]; then
        unset WINEPREFIX
    fi
    if [[ -d $HOME/.arrowvortex ]]; then
        export WINEPREFIX=$HOME/.arrowvortex
    else
        printf "WINEPREFIX Path: "
        read -r winePrefixPath
        if [[ -z $winePrefixPath ]]; then
            echo "Error: No Path Provided\!"
            return 1
        else
            if [[ -n $WINEPREFIX ]]; then
                unset WINEPREFIX
            fi
            export WINEPREFIX=$winePrefixPath
        fi
    fi
}

_avtx_get_exe_path() {
    if [[ -n $EXEPATH ]]; then
        unset EXEPATH
    fi
    if [[ -f /mnt/ArrowVortex/ArrowVortex.exe ]]; then
        export EXEPATH=/mnt/ArrowVortex/ArrowVortex.exe
    else
        printf "ArrowVortex.exe Path: "
        read -r arrowVortexPath
        if [[ -z $arrowVortexPath ]]; then
            echo "Error: No Path Provided\!"
            return 1
        else
            export EXEPATH=$arrowVortexPath
        fi
    fi
}

arrowvortex() {
    _avtx_get_wineprefix
    _avtx_get_exe_path
    if [[ -f $EXEPATH ]] && [[ -d $WINEPREFIX ]]; then
        wine $EXEPATH
    else
        echo "Error: Existence Error"
        return 1
    fi
}
