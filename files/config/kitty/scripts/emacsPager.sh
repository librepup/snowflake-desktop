#!/usr/bin/env zsh

tmp=$(mktemp)

# Strip all ANSI escape sequences from stdin
#sed -r 's/\x1B\[[0-9;]*[mK]//g' > "$tmp"

cat > $tmp

# Open the cleaned text in Emacs client
emacsclient -nw --eval "
(with-current-buffer (find-file \"$tmp\")
  (view-mode)
  (goto-char (point-min))
  (add-hook 'kill-buffer-hook (lambda () (ignore-errors (delete-file \"$tmp\")))))"
