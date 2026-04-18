#!/usr/bin/env bash
# Serve HTTP Server in Current Directory

serve() {
  local port
  if [ -z "$1" ]; then
    port=8000
  else
    port="$1"
  fi
  nix-shell -p python3 --run "python3 -m http.server "$port""
}
