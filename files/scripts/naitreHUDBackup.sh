#!/usr/bin/env bash

backupDir="$HOME/Projects/NaitreHUD"
currentDate=$(date | sed 's/ /_/g')
defaultSourceDir="$HOME/NaitreHUD"

mkdir -p "$backupDir"
read -r -p "[ Original/Source Directory? ] ~> " sourceInput

if [[ -z "$sourceInput" ]]; then
    read -r -p "[ No directory given. Use '$defaultSourceDir'? (Y/n) ] ~> " confirm
    case "$confirm" in
        ""|y|Y|yes|YES)
            sourceDir="$defaultSourceDir"
            ;;
        *)
            echo "[ Aborted: no source directory selected ]"
            exit 1
            ;;
    esac
else
    sourceDir=$(eval echo "$sourceInput")
fi

read -r -p "[ Add Comment to Backup Folder? ] (Comment Here:) ~> " commentContents
if [[ -z "$commentContents" ]]; then
    comment=""
else
    comment="$commentContents"
fi

if [[ -z "$sourceDir" || ! -d "$sourceDir" ]]; then
    echo "[ Error: '$sourceDir' is not a valid directory! ]"
    exit 1
fi

maxNum=$(ls -1 "$backupDir" 2>/dev/null \
	     | sed -n 's/^\([0-9]\+\)-.*/\1/p' \
	     | sort -n \
	     | tail -n 1)

if [[ -z "$maxNum" ]]; then
    num=1
else
    num=$((maxNum + 1))
fi

cp -r "$sourceDir" "$backupDir/''${num}---NaitreHUD-''${currentDate}---''${comment}"
