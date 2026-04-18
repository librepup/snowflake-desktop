{ config, pkgs, lib, unstable, ... }:
{
  imports = [
    ./desktops/default.nix
    ./theme.nix
    ./xdg.nix
    ./files.nix
    ./programs/default.nix
  ];
}
