#!/usr/bin/env bash

help() {
    if [ $# -eq 0 ]; then
        echo -e "Shell Help: USAGE
Options
  nix         - Show Nix related Help Screen
  down        - Show Downloader Help Screen
  git         - Show Git Help Screen
  archive     - Show Archiving Help Screen
  extra       - Show Various Extra Commands Help Screen
  fetch       - Show Fetcher related Help Screen
  edit        - Show Editing related Help Screen
  gaming      - Show Gaming Help Screen
"
        return 1
    fi
    arg=$1
    case $arg in
        *shell*)
            echo -e "Shell Help: SHELL Options
Shells
  zsh            - The Z Shell
  bash           - GNU Bourne-Again Shell
  sh             - /bin/sh Shell
  xonsh          - Python-Powered Shell
  pwsh           - Microsoft PowerShell
  nu             - Modern Rust-Based Shell
  rc             - The Plan9 Shell

"
            return 1
            ;;
        *game*|*gaming*|*steam*)
            echo -e "Shell Help: GAMING Options
Gaming
  Wine
    wine         - Run Windows Executables with Wine (Yabridge)
    winetricks   - Manage Virtual Windows Environments using Wine
  Proton
    protonup     - Manage Additional Proton Builds
    - protonup     - Install and Manage Additional Proton Builds via the Terminal
    - protonup-qt  - Install and Manage Additional Proton Builds via a GUI
    protontricks - Wrapper for Running Winetricks Command for Steam/Proton Games
  Extra
    nero-umu     - Launch Windows Executables within a Nero-Manager Prefix (with UmU)
Tools
  mangohud     - Monitor FPS and Other Statistics In-Game
Games
  Standalone
    osu-stable   - Run osu\!stable using Fufexan's Nix-Gaming osu\! Wrapper
    osu\!        - osu\!lazer AppImage Wrapper/Binary
    notitg       - Run NotITG via librepup's Jonabron NotITG Wrapper
    notitg-kill  - Safely Kill and Stop all NotITG related Processes
  Launchers
    steam        - Valve's Gaming Platform
"
            return 1
            ;;
        *nix*)
            echo -e "Shell Help: NIX Options
  Nix
    rebuild            - Rebuild System
    garbage            - Collect Garbage
    ns                 - Run Nix-Shell with ZSH
    nss                - Nix-Search-CLI (Package Search)
    no                 - Manix (Options Search)
    nixgethash         - Get Hash of .tar.gz or Git Repository
    arcan console lash - Arcan Lash/Cat9 Shell
  "
            return 1
            ;;
        *fetch*)
            echo -e "Shell Help: FETCH Options
  Fetchers
    hf          - HyFetch
    ff          - FastFetch
    pf          - PrideFetch
    mf          - MicroFetch
    of          - OneFetch
  "
            return 1
            ;;
        *down*)
            echo -e "Shell Help: DOWNLOADER Options
  Downloaders
    mp3         - Download URL as MP3
    mp4         - Download URL as MP4
    mp4fallback - Fallback URL to MP4 Downloader
    mpget       - Download URL as MP3, set Cover, and apply Tags
  "
            return 1
            ;;
        *git*)
            echo -e "Shell Help: GIT Options
  Git Helper
    g c         - Clone Repository
    g aa        - Add All Files to Repository
    g co        - Commit Changes with Comment
    g p         - Git Push Changes to Remote Repository
  "
            return 1
            ;;
        *credit*|*cred*|*about*)
            echo -e "Shell Help: CREDIT
Credit
  Creator     - librepup
    GitHub      - https://github.com/librepup
    Discord     - @puppyfailure
    Steam       - https://steamcommunity.com/id/librepup/
    Twitter     - https://x.com/librepup
    Website     - http://onyx-7.de
"
            return 1
            ;;
        *ed*)
            echo -e "Shell Help: EDITOR Options
  Editors
    nixmacs        - NixMacs Graphical Editor
    nixmacs-client - NixMacs Client (emacsclient) Binary
    nvim           - Nix-(N)Vim Editor
  Aliases
    ec             - NixMacs Client (with: \"-c -nw\" Options)
    e              - NixMacs (with: \"-nw\" Options)
    vim            - NixMacs (with: \"-nw\" Options)
    vi             - Nix-(N)Vim Alias/Link
  "
            return 1
            ;;
        *arc*)
            echo -e "Shell Help: ARCHIVING Options
  Archiving
    zipCreate   - Create Zip Archive
    tarZip      - Create Tar Archive
    tarUnzip    - Extract Tar Archive
    tarShow     - Show Contents of Tar Archive
  "
            return 1
            ;;
        *extra*|*other*)
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
            ;;
        *)
            echo -e "Shell Help: USAGE
Options
  nix         - Show Nix related Help Screen
  down        - Show Downloader Help Screen
  git         - Show Git Help Screen
  archive     - Show Archiving Help Screen
  extra       - Show Various Extra Commands Help Screen
  fetch       - Show Fetcher related Help Screen
  edit        - Show Editing related Help Screen
  gaming      - Show Gaming Help Screen
"
            return 1
            ;;
esac
}
