#!/usr/bin/env zsh

gobm_preexec() {
    [[ "$1" == gobm* ]] && return
    if [[ "$1" == *"osu.ppy.sh/beatmapsets"* ]]; then
        gobm "$1"
    fi
}

video_preexec() {
    local -a parts
    parts=(${(z)1})

    (( ${#parts} == 1 )) || return

    local file="${(Q)parts[1]}"
    [[ "$file" == mpv* ]] && return
    if [[ "$file" =~ [^*]\.(mp4|mov|webm|mkv|mp3|ogg|wav|flac)$ ]]; then
        devour mpv "$file"
    fi
}

preexec_functions+=(gobm_preexec)
preexec_functions+=(video_preexec)
