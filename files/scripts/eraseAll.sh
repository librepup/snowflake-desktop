#!/usr/bin/env bash

clipboardItems=$(echo "$(copyq count)")

_cleanUpFunc() {
    index=0
    clipboardItems=$((clipboardItems - 1))
    rm -rf $HOME/.cache/thumbnails/*/*
    if [[ $clipboardItems -lt 0 ]] || [[ $clipboardItems == "" ]] || [[ $clipboardItems == "0" ]] || [[ -z $clipboardItems ]]; then
        notify-send "Error" "Cleanup Failed" -i $HOME/Pictures/Icons/error.png
        return 1
    fi
    while [ ! $index -eq $clipboardItems ]; do
        copyq remove $clipboardItems
        clipboardItems=$((clipboardItems - 1))
    done
    copyq remove 0
}

_cleanUpFunc && notify-send "Success" "Performed Global Cleanup" -i $HOME/Pictures/Icons/yes.png || notify-send "Error" "Cleanup Failed" -i $HOME/Pictures/Icons/error.png
