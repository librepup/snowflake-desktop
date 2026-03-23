{ config, pkgs, lib, unstable, ... }:
{
  imports = [
    ./desktops/default.nix
    ./theme.nix
    ./xdg.nix
    ./music.nix
    ./files.nix
    ./programs.nix
    ./editors.nix
  ];
}
