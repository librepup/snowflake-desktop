#!/usr/bin/env bash

tmux kill-session -t "main" 2>/dev/null
tmux new-session -d -s "main" "keymon" \; split-window -h "doas keyd monitor" \; split-window -v "doas keyd listen" \; attach
