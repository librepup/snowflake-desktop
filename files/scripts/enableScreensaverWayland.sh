#!/bin/sh

wayidle -w timeout 300 'dms ipc call lock lock'
notify-send 'Screensaver' 'Turned ON.' -i /home/puppy/Pictures/yes.png
