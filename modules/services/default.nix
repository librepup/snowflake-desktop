{ config, pkgs, inputs, ... }:
{
  imports = [
    ./guix.nix
    ./networks.nix
    ./virtualization.nix
    ./flatpak.nix
  ];
}
