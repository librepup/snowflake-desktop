#!/usr/bin/env bash

ff-gigi() {
    fastfetch --logo ~/.config/fastfetch/images/gigi.png --logo-width 25 --logo-height 20 $@
}

ff-mori() {
    if [ $# -eq 0 ]; then
        fastfetch --logo ~/.config/fastfetch/images/mori02.png --logo-width 25 --logo-height 20
        return 0
    fi
    local arg
    arg=$1
    if [[ "$arg" == 2 ]] || [[ "$arg" == *Two* ]] || [[ "$arg" == *two* ]]; then
        fastfetch --logo ~/.config/fastfetch/images/mori02.png --logo-width 25 --logo-height 20
        unset arg
        return 0
    else
        fastfetch --logo ~/.config/fastfetch/images/mori01.png --logo-width 25 --logo-height 20
        unset arg
        return 0
    fi
}
