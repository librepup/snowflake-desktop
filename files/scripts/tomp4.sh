#!/usr/bin/env bash

tomp4() {
    if [ $# -eq 0 ]; then
        echo "Usage: tomp4 <file>"
        return 1
    fi
    random=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12)
    file=$1
    output="$(echo "output-${random}.mp4")"
    ffmpeg -i $file -c copy $output
    echo "Success: Created '${output}'."
}
