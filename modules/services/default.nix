{ config, pkgs, inputs, ... }:
{
  imports = [
    # ./containerization.nix
    ./guix.nix
    ./networks.nix
    ./virtualization.nix
    ./flatpak.nix
    ./authentication.nix
    ./printing.nix
    ./tablet.nix
    ./ibus.nix
    ./appimage.nix
    ./ai.nix
    ./snap.nix
    ./keyd.nix
    ./mouse.nix
  ];
}
