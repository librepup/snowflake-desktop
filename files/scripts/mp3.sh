#!/usr/bin/env bash

mp3() {
    if [ $# -eq 0 ]; then
        echo "Error: No URL Provided"
        return 1
    fi
    local videoTitle=$(yt-dlp --quiet --no-warnings --parse-metadata "title:(?P<artist>.+?) - (?P<title>.+)" --parse-metadata ":(?P<artist>%{uploader}s)|(?P<title>%{title}s)" --print "%(artist)s - %(title)s" "$@")
    yt-dlp -f bestaudio \
              --quiet \
              --no-warnings \
              --progress \
              --extract-audio \
              --audio-format mp3 \
              --embed-thumbnail \
              --convert-thumbnails jpg \
              --ppa "ffmpeg: -c:v mjpeg -vf crop=\"'if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'\"" \
              --parse-metadata "title:(?P<artist>.+?) - (?P<title>.+)" \
              --parse-metadata ":(?P<artist>%{uploader}s)|(?P<title>%{title}s)" \
              --add-metadata \
              -o "%(artist)s - %(title)s.%(ext)s" \
              "$@"
    if [ $? -eq 0 ]; then
        echo "Successfully Downloaded: \"${videoTitle}\"."
    else
        echo "Error: Download Failed"
    fi
}
