#!/usr/bin/env bash

ffmpeg -i "$1" "${1}".gif

# ffmpeg -i $1 -vf "fps=10,scale=320:-1:flags=lanczos" -loop 0 ${arg}.gif
