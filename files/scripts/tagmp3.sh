#!/usr/bin/env bash

if [ $# -eq 0 ]; then
    echo "Usage: tagmp3 /path/to/song.mp3 /path/to/cover.png"
    exit 1
fi

audioFile=$1
albumArt=$2

if [[ -z "$audioFile" ]]; then
    echo "Usage: tagmp3 /path/to/song.mp3 /path/to/cover.png"
    exit 1
fi
if [[ -z "$albumArt" ]]; then
    echo "Usage: tagmp3 /path/to/song.mp3 /path/to/cover.png"
    exit 1
fi

printf "Song Title: "
read -r songTitle
if [[ -z "$songTitle" ]]; then
    echo "Error: No Title Provided"
    exit 1
fi

printf "Artist Name: "
read -r songArtist
if [[ -z "$songArtist" ]]; then
    echo "Error: No Artist Provided"
    exit 1
fi

outputAudioFile="output-${audioFile}"

ffmpeg -i "$audioFile" -i "$albumArt" \
       -metadata title="$songTitle" \
       -metadata artist="$songArtist" \
       -map 0:0 -map 1:0 \
       -disposition:v:0 attached_pic \
       -codec copy "$outputAudioFile"

echo "Wrote: ${outputAudioFile}"
