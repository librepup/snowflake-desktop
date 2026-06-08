#!/usr/bin/env bash

feh --geometry \
    --ignore-aspect \
    --recursive \
    --auto-zoom \
    --zoom max \
    --no-menus \
    --draw-filename \
    --zoom-step 10 \
    --scale-down \
    --slideshow-delay '-1' \
    --font 'SourceCode Pro for Powerline' \
    --image-bg '#000000' \
    --auto-reload \
    "$@"
