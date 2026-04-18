#!/usr/bin/env bash
# General Functions
### c d-Directory Function
function c() {
  if [[ $1 == d* ]]; then
    local target="''${1#d}"
    builtin cd "$target"
  else
    echo "Usage: c d<directory>"
  fi
}

### Echo Out File
echoout() {
  echo "$(<"$1")"
}

### Progress Bar Move
move() {
  command mv "$@" &
  pid=$!
  progress -mp $pid
  wait $pid
}

### File Edit Picker
edit() {
  local file
  file=$(fzf) || return
  nixmacs -nw "$file"
}

### Trash
trash() {
  local file="$1"
  local dir="$HOME/.local/share/Trash/files"
  mkdir -p "$dir"
  mv "$file" "$dir"
  echo "Moved $file to Trash."
}

### Backup Files
backup() {
  if [ -z "$1" ]; then
    echo "Usage: backup <File>"
    return 1
  fi
  cp -r "$1" "$1.$(date +%Y%m%d_%H%M%S).backup"
}

### Get 9 Binary Path
getNineBinPath() {
  export NINEBINPATH=$(ls -la $(which 9) | awk '{print $9}' | sed "s/\/bin\/9/\/plan9\/bin/g")
}
