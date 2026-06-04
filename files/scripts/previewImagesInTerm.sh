#!/usr/bin/env bash]

img() {
    local MIN_CELL_W=20
    local MIN_CELL_H=$(( MIN_CELL_W / 2))

    local termWidth termHeight
    read -r termHeight termWidth < <(stty size)

    local MAX_COLS=$(( termWidth / MIN_CELL_W ))
    local MAX_ROWS=$(( termHeight / MIN_CELL_H ))

    local fileCount cols rows
    #fileCount=$(find . -maxdepth 1 -type f | wc -l)
    fileCount=$(find . -maxdepth 1 \( -type f -o -iname '*.png' -o -iname '*.jpg' -o -iname '*.webp' -o -iname '*.jpeg' -o -iname '*.avif' -o -iname '*.ico' -o -iname '*.bmp' \)| wc -l)
    cols=$(( fileCount < MAX_COLS ? fileCount : MAX_COLS ))
    rows=$(( (fileCount + cols - 1) / cols ))
    rows=$(( rows < MAX_ROWS ? rows : MAX_ROWS ))
    while (( fileCount % cols != 0 && cols > 1 )); do
        (( cols-- ))
    done
    rows=$(( fileCount / cols ))
    rows=$(( rows < MAX_ROWS ? rows : MAX_ROWS ))

    local x=$(( ( termWidth / ( MAX_COLS / cols ) ) ))
    local y=$(( termHeight / rows ))

    timg ./* --upscale=i --fit-width --center --title --grid="${cols}x${rows}" -g"${x}x${y}" -b "#FFFFFF" -B "#000000" 2>/dev/null
}
