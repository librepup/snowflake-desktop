#!/usr/bin/env bash

arg=$1

ffmpeg -i $1 -vf "fps=10,scale=320:-1:flags=lanczos" -loop 0 ${arg}.gif
