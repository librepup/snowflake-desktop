#!/usr/bin/env bash
# View Screenshots from your Clipboard

# Define randomized Filename
fileName=$((10000 + $RANDOM % 1000000000))

# If image in clipboard, run process; else send error notification.
if xclip -selection clipboard -t image/png -o &> /dev/null; then
    # Export clipboard image to /home/$USER/ with a random file name.
    xclip -selection clipboard -t image/png -o > $HOME/"$fileName.png"
    # Open MPV with i3-compatible title to make it automatically float.
    mpv --force-window=yes --title="FLOAT_MP" "$HOME/$fileName.png"
    # Delete temporary image.
    rm "$HOME/$fileName.png"
else
    # Send notification with context.
    notify-send "Error" "No image found in clipboard!" -i $HOME/Pictures/error.png
fi
