#!/usr/bin/env bash

# Convert To
r=$1
shift 1

case $r in
  png)
    unset r
    r="png"
    ;;
  jpg)
    unset r
    r="jpg"
    ;;
  webp)
    unset r
    r="webp"
    ;;
esac

# Files
f=("$@")

# Conversion
for e in "${f[@]}"; do
    if [[ -n $d ]]; then
        unset d
    fi
    d=$(echo "${e}" | sed -E "s/\.[^.]*\$/\.${r}/")
    magick "${e}" "${d}"
    unset d
done

unset f d e r
