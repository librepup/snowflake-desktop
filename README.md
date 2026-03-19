# snowflake
Configuration Files for my Desktop Computer, using an Nvidia GTX 1080.

# Specifications
## System
 - OS: NixOS 25.11
 - Kernel: Custom CachyOS Kernel
 - GPU: Proprietary Nvidia Drivers
 - Window Manager: XMonad
   - Available: XMonad, i3-gaps, NaitreHUD, MangoWC, KDE Plasma, GNOME
 - Editor: NixMacs
   - Available: NixVim (neovim), Emacs (emacs-x11, emacs-wayland), NixMacs (nixmacs, nixmacs-wayland), Nano (nano), Acme (acme)
 - Shell: ZSH (Oh-My-Zsh)
   - Available: ZSH, Bash, /bin/sh
 - Terminal: Kitty
   - Available: Kitty, Alacritty, XTerm
 - Display Manager: SDDM
 - Audio: Low-Latency PipeWire
   - Enabled: Low-Latency PipeWire, Alsa/Alsa32, Pulse, Jack, Wireplumber
 - BIOS: (U)EFI
 - Bootloader: GRUB
   - Theme: inputs.jonabron.packages.x86_64-linux.dangerousjungle-grub-theme

## Gaming
 - Steam Installed (with Proton-GE, and Millenium Themes)
 - Nix-Gaming Installed
 - OpenTabletDriver Installed
 - Input-Remapper Installed

## Networks
 - I2P Installed (Disabled by Default)
 - Tor Installed (Disabled by Default)
 - Yggdrasil Installed (Disabled by Default)
 - Urbit Installed

## Extras
 - Home-Manager Installed
 - Guix Package Manager Installed

# Settings
## osu!
 - Keys
   - osu!standard
     - X | Z
   - osu!mania
     - Z | X | . | /
 - Screen
   - Resolution: 1024x768
   - Horizontal Offset: -15%
   - Vertical Offset: -60%
 - Tablet
   - Tablet Area
     - Width: 70mm
     - Height: 57mm
     - X: 35mm
     - Y: 28.5mm
     - Rotation: 1
   - Tablet Display
     - Width: 1920px
     - Height: 1080px
     - X: 960px
     - Y: 540px
   - Plugins
     - Additional Keys
     - Monitor Toggle
   - Auxiliary Settings
     - Auxiliary Binding 1: Additional - F13-F24: (Key: F16)
     - Auxiliary Binding 2: Additional - F13-F24: (Key: F17)
     - Auxiliary Binding 3: Monitor Toggle: (offset_x:0), (offset_y:0), (width_multiplier:1), (height_multiplier:1), (mode:Cycle)
     - Auxiliary Binding 4: Monitor Toggle: (offset_x:1920), (offset_y:0), (width_multiplier:1), (height_multiplier:1), (mode:Cycle)

## Keyboard Remaps
### Located in `files/config/input-remapper-2` and `files/config/xmodmap`.
Remapped the following Keys:
 - XModMap:
   - AltGr -> Space
   - RightCtrl -> AltGr
   - Insert -> Tab
   - RightShift -> Super
 - InputRemapper:
   - F16 -> RightClick
   - F17 -> LeftClick
