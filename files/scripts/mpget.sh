#!/usr/bin/env bash

mpget() {
    if [ $# -eq 0 ]; then
        echo "Please provide a valid YouTube URL to any Song you want to download."
        return 1
    fi
    arg=$1
    if [[ "$arg" == *http* ]]; then
        yt-dlp --quiet -x --audio-format mp3 --embed-thumbnail --embed-metadata -o "%(uploader)s - %(title)s.%(ext)s" "$arg"
        echo "Downloaded: (${arg}) to current directory."
        return 1
    else
        echo "Error: The URL you specified does not seem to be a valid HTTP(S) Address."
        return 1
    fi
}
