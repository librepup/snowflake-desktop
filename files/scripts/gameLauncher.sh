#!/usr/bin/env bash

#/- -- -- -- -- -- -- -- -- -\#
#|==+=+=+=+=+=+=+=+=+=+=+=+==|#
#|  Graphical Game Launcher  |#
#|          / GaLor \        |#
#|==-=-=-=-=-=-=-=-=-=-=-=-==|#
#|  By @librepup             |#
#|        aka @puppyfailure  |#
#|==+=+=+=+=+=+=+=+=+=+=+=+==|#
#\- -- -- -- -- -- -- -- -- -/#

# Shell Script Options - Required to Unset All Variables at the End
shopt -s extglob
mapfile -t _initial < <(compgen -v)

# Variables
ITEMS=()
ICON_DIR="/etc/nixos/files/pictures/icons"

# Functions
errorMsg() {
    if [[ -f "${ICON_DIR}/error.png" ]]; then
        notify-send "Unknown Option '$CHOICE'!" "Please Try Again and Pick a Valid Game." --icon="${ICON_DIR}/error.png" --expire-time=2000 --urgency=critical
    else
        notify-send "Unknown Option '$CHOICE'!" "Please Try Again and Pick a Valid Game." --expire-time=2000 --urgency=critical
    fi
    return 1
    exit 1
}
itgManiaCheck() {
    if command -v itgmania > /dev/null; then
        export ITGMANIA_BIN="$(realpath "$(which itgmania)")"
        export ITGMANIA_ICON=$(echo "${ITGMANIA_BIN}" | sed 's|/bin/itgmania|/share/icons/hicolor/scalable/apps/itgmania.svg|g' | tr -d '\n')
        ITEMS+=("ITGMania|${ITGMANIA_ICON}")
    fi
}
outFoxCheck() {
    if command -v OutFox > /dev/null; then
        export OUTFOX_BIN="$(realpath "$(which OutFox)")"
        export OUTFOX_ICON=$(echo "${OUTFOX_BIN}" | sed 's|/bin/OutFox|/share/OutFox/Docs/Luadoc/favicon.ico|g' | tr -d '\n')
        ITEMS+=("OutFox|${OUTFOX_ICON}")
    fi
}
etternaCheck() {
    if command -v etterna > /dev/null; then
        export ETTERNA_BIN="$(realpath "$(which etterna)")"
        export ETTERNA_ICON=$(echo "${ETTERNA_BIN}" | sed 's|/bin/etterna|/share/icons/hicolor/scalable/apps/etterna.svg|g' | tr -d '\n')
        ITEMS+=("Etterna|${ETTERNA_ICON}")
    fi
}
osuLazerCheck() {
    if command -v osu\! > /dev/null; then
        export OSULAZER_BIN="$(realpath "$(which osu\!)")"
        export OSULAZER_ICON=$(echo "${OSULAZER_BIN}" | sed 's|/bin/osu!|/share/icons/hicolor/1024x1024/apps/osu.png|g' | tr -d '\n')
        ITEMS+=("osu!lazer|${OSULAZER_ICON}")
    fi
}
osuStableCheck() {
    if command -v osu-stable > /dev/null; then
        export OSUSTABLE_BIN="$(realpath "$(which osu-stable)")"
        if [[ -f "/etc/nixos/files/pictures/icons/osu.png" ]]; then
            export OSUSTABLE_ICON="/etc/nixos/files/pictures/icons/osu.png"
        else
            export OSUSTABLE_ICON="Terminal"
        fi
        ITEMS+=("osu!stable|${OSUSTABLE_ICON}")
    fi
}
soundVoltexCheck() {
    if command -v usc-game-wrapped > /dev/null; then
        if [[ -f "/etc/nixos/files/pictures/icons/sdvx.png" ]]; then
            export SDVX_ICON="/etc/nixos/files/pictures/icons/sdvx.png"
        else
            export SDVX_ICON="Terminal"
        fi
        ITEMS+=("SDVX|${SDVX_ICON}")
    fi
}
notItgCheck() {
    if command -v notitg > /dev/null; then
        if [[ -f "/etc/nixos/files/pictures/icons/notitg.png" ]]; then
            export NOTITG_ICON="/etc/nixos/files/pictures/icons/notitg.png"
        else
            export NOTITG_ICON="Terminal"
        fi
        ITEMS+=("NotITG|${NOTITG_ICON}")
    fi
}
quaverCheckInstallStatus() {
    if [[ -f "/tmp/QuaverInstallationStatus.DD" ]] && [[ $(cat /tmp/QuaverInstallationStatus.DD) != "1" ]]; then
        rm /tmp/QuaverInstallationStatus.DD
    fi
    if command -v steam > /dev/null && find / \
        \( -path /proc -o -path /sys -o -path /dev -o -path /run \) -prune \
        -o -name 'appmanifest_980610.acf' -print -quit 2>/dev/null | \
        grep -q .
    then
        echo "1" >> /tmp/QuaverInstallationStatus.DD
    fi
    if [[ $(cat /tmp/QuaverInstallationStatus.DD) == "1" ]]; then
        QUAVER_ICON="/etc/nixos/files/pictures/icons/quaver.ico"
        if [[ -f "${QUAVER_ICON}" ]]; then
            ITEMS+=("Quaver|${QUAVER_ICON}")
        else
            ITEMS+=("Quaver|Terminal")
        fi
    fi
}
quaverDetection() {
    catInstallStatus=$(cat /tmp/QuaverInstallationStatus.DD 2>/dev/null | tr -d '\n')
    if [[ $catInstallStatus == "1" ]]; then
        QUAVER_ICON="/etc/nixos/files/pictures/icons/quaver.ico"
        if [[ -f "${QUAVER_ICON}" ]]; then
            ITEMS+=("Quaver|${QUAVER_ICON}")
        else
            ITEMS+=("Quaver|Terminal")
        fi
    else
        quaverCheckInstallStatus
    fi
}
choiceHandling() {
    if [[ -n $CHOICE ]]; then
        unset CHOICE
    fi
    soundVoltexCheck
    osuLazerCheck
    osuStableCheck
    notItgCheck
    quaverDetection
    etternaCheck
    outFoxCheck
    itgManiaCheck
    RAW_CHOICE=$( \
        for item in "${ITEMS[@]}"; do \
            NAME="${item%%|*}"; \
            ICON="${item#*|}"; \
            printf "%s\0icon\x1f%s\n" "$NAME" "$ICON"; \
        done | rofi \
            -dmenu \
            -p "Launch Game..." \
            -show-icons \
            -theme-str 'listview { columns: 3; lines: 2; } element { orientation: vertical; padding: 5px; }')
    CHOICE=$(echo "$RAW_CHOICE" | awk '{print $0}')
}

# Initialize Choice
choiceHandling

# Choice Execution
case "$CHOICE" in
    "osu!lazer") \
        osu!; \
        echo "Ran osu\!lazer."; \
        ;;
    "osu!stable") \
        osu-stable; \
        echo "Ran osu\!stable."; \
        ;;
    "NotITG") \
        notitg; \
        echo "Ran NotITG."; \
        ;;
    "Etterna") \
        etterna; \
        echo "Ran Etterna."; \
        ;;
    "OutFox") \
        OutFox; \
        echo "Ran OutFox."; \
        ;;
    "ITGMania") \
        itgmania; \
        echo "Ran ITGMania."; \
        ;;
    "SDVX") \
        if command -v gamemoderun > /dev/null; then \
            gamemoderun usc-game-wrapped; \
        else \
            usc-game-wrapped; \
        fi; \
        echo "Ran SDVX."; \
        ;;
    "Quaver") \
        cd $HOME; steam "steam://rungameid/980610//gamemoderun %command%"; \
        echo "Ran Quaver."; \
        ;;
    "!credits"|"!Credits") \
        notify-send \
            "Credits" \
            "Written by '@librepup' on GitHub, and '@puppyfailure' on Discord\!\n\nThank you for using\!" \
            --expire-time=2000 \
            --urgency=low; \
        ;;
    "") \
        ;;
    *) \
        errorMsg; \
        ;;
esac

# Unset Script Variables
for v in $(compgen -v); do
  case " ${_initial[*]} " in
    *" $v "*) ;;
    *) unset "$v" ;;
  esac
done
unset _initial
