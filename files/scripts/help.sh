#!/bin/sh

help() {
    if [ $# -eq 0 ]; then
        echo "Usage: help <nix/down/git/archive/extra/fetch/edit/all>"
        return 1
    fi
    arg=$1
    if [[ "$arg" == *nix* ]]; then
        echo -e "Shell Help: NIX Options
Nix
  rebuild     - Rebuild System
  garbage     - Collect Garbage
  ns          - Run Nix-Shell with ZSH
  nss         - Nix-Search-CLI (Package Search)
  no          - Manix (Options Search)
  nixgethash  - Get Hash of .tar.gz or Git Repository
"
        return 1
    elif [[ "$arg" == *fetch* ]]; then
        echo -e "Shell Help: FETCH Options
Fetchers
  hf          - HyFetch
  ff          - FastFetch
  pf          - PrideFetch
  mf          - MicroFetch
  of          - OneFetch
"
        return 1
    elif [[ "$arg" == *down* ]]; then
        echo -e "Shell Help: DOWNLOADER Options
Downloaders
  mp3         - Download URL as MP3
  mp4         - Download URL as MP4
  mp4fallback - Fallback URL to MP4 Downloader
"
    elif [[ "$arg" == *git* ]]; then
        echo -e "Shell Help: GIT Options
Git Helper
  g c         - Clone Repository
  g aa        - Add All Files to Repository
  g co        - Commit Changes with Comment
  g p         - Git Push Changes to Remote Repository
"
        return 1
    elif [[ "$arg" == *ed* ]]; then
        echo -e "Shell Help: EDITOR Options
Editors
  ec          - EmacsClient
  e           - NixMacs
"
        return 1
    elif [[ "$arg" == *arc* ]]; then
        echo -e "Shell Help: ARCHIVING Options
Archiving
  zipCreate   - Create Zip Archive
  tarZip      - Create Tar Archive
  tarUnzip    - Extract Tar Archive
  tarShow     - Show Contents of Tar Archive
"
        return 1
    elif [[ "$arg" == *extra* ]] || [[ "$arg" == *other* ]]; then
        echo -e "Shell Help: EXTRA Options
Extra
  weather     - Show Weather
  htop        - Process Viewer
  iftop       - Bandwidth Viewer
  forcekill   - Force-Kill Process (PID)
  analogcity  - Connect to AnalogCity Board
  shreddy     - Shred Path
  ipinfo      - Show Info about Current IP
  translate   - Translate Text in Shell
  disks       - Show Disks (Arg: type, for Details)
  keymon      - Read Keyboard Typed/Inputted Keys
  bible       - Study the Bible
  explorer    - Open CLI File Explorer
"
        return 1
    elif [[ "$arg" == *all* ]]; then
        echo -e "Shell Configuration: ALL Options
Nix
  rebuild     - Rebuild System
  garbage     - Collect Garbage
  ns          - Run Nix-Shell with ZSH
  nss         - Nix-Search-CLI (Package Search)
  no          - Manix (Options Search)
  nixgethash  - Get Hash of .tar.gz or Git Repository

Downloaders
  mp3         - Download URL as MP3
  mp4         - Download URL as MP4
  mp4fallback - Fallback URL to MP4 Downloader

Archiving
  zipCreate   - Create Zip Archive
  tarZip      - Create Tar Archive
  tarUnzip    - Extract Tar Archive
  tarShow     - Show Contents of Tar Archive

Git Helper
  g c         - Clone Repository
  g aa        - Add All Files to Repository
  g co        - Commit Changes with Comment
  g p         - Git Push Changes to Remote Repository

Extra
  weather     - Show Weather
  htop        - Process Viewer
  iftop       - Bandwidth Viewer
  forcekill   - Force-Kill Process (PID)
  analogcity  - Connect to AnalogCity Board
  shreddy     - Shred Path
  ipinfo      - Show Info about Current IP
  translate   - Translate Text in Shell
  disks       - Show Disks (Arg: type, for Details)
  keymon      - Read Keyboard Typed/Inputted Keys
  bible       - Study the Bible
  explorer    - Open CLI File Explorer

Fetchers
  hf          - HyFetch
  ff          - FastFetch
  pf          - PrideFetch
  mf          - MicroFetch
  of          - OneFetch

Editors
  ec          - EmacsClient
  e           - NixMacs
"
        return 1
    else
        echo "Usage: help <nix/down/git/archive/extra/fetch/edit/all>"
        return 1
    fi
}
