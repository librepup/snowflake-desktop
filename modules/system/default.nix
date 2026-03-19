{ config, pkgs, inputs, ... }:
{
  imports = [
    ./audio.nix
    ./networking.nix
    ./nvidia.nix
    ./xorg.nix
    ./fonts.nix
    ./packages.nix
    ./nix.nix
    ./security.nix
    ./bootloader.nix
    ./xdg.nix
    ./kernel.nix
    ./environment.nix
    ./region.nix
    ./filesystem.nix
  ];
}
