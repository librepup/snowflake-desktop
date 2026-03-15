{ config, pkgs, lib, unstable, ... }:
{
  imports = [
    ./desktops.nix
    ./theme.nix
    ./xdg.nix
    ./music.nix
    ./files.nix
    ./programs.nix
    ./editors.nix
  ];
}
