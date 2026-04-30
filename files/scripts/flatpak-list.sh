#!/usr/bin/env zsh

flatpak-list() {
  local column12=$(flatpak list --columns=application,size,description | sort -u | awk '{print "Run: "$1"\n""Size: "$2}')
  local column3=$(flatpak list --columns=application,size,description | sort -u | awk '{$1=$2=""; print "Description: "$0}')
  if [[ -f /tmp/col12.txt ]]; then
    rm /tmp/col12.txt 2>/dev/null
  fi
  if [[ -f /tmp/col3.txt ]]; then
    rm /tmp/col3.txt 2>/dev/null
  fi
  printf '%s\n' "$column12" > /tmp/col12.txt
  printf '%s\n' "$column3" > /tmp/col3.txt
  if [[ -f /tmp/col12_pairs.txt ]]; then
    rm /tmp/col12_pairs.txt 2>/dev/null
  fi
  awk 'NR%2{a=$0;next}{print a "\t" $0}' /tmp/col12.txt > /tmp/col12_pairs.txt
  paste -d '\t' /tmp/col12_pairs.txt /tmp/col3.txt | awk -F'\t' '{print $1 "\n" $2 "\n" $3"\n"}' | __bat_stylize_cmd
  rm /tmp/col12_pairs.txt 2>/dev/null
  rm /tmp/col3.txt 2>/dev/null
  rm /tmp/col12.txt 2>/dev/null
}

__bat_stylize_cmd() {
  bat --paging=auto \
    --theme=dark \
    --theme-dark=Catppuccin\ Frappe \
    --tabs=4 \
    --wrap=auto \
    --color=always \
    --squeeze-blank \
    --squeeze-limit=1 \
    --strip-ansi=always \
    --number \
    --language=Rego \
    --no-config \
    --set-terminal-title \
    --file-name="Flatpak List" \
    "$@"
}
