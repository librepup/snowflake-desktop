{ config, pkgs, inputs, ... }:
{
  imports = [
    # ./containerization.nix
    ./apple.nix
    ./speech.nix
    ./guix.nix
    ./networks.nix
    ./virtualisation.nix
    ./flatpak.nix
    ./authentication.nix
    ./printing.nix
    ./tablet.nix
    ./ibus.nix
    ./appimage.nix
    ./ai.nix
    ./snap.nix
    # ./keyd.nix # Moved to modules/system/keyboard.
    ./mouse.nix
  ];
}
