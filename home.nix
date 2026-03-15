{ config, pkgs, lib, inputs, unstable, ... }:
{
  imports = [
    ./modules/home/default.nix
  ];
  home.username = "puppy";
  home.homeDirectory = "/home/puppy";
  home.stateVersion = "25.05";
  home.sessionVariables = {
    XDG_DATA_DIRS = "$HOME/.guix-profile/share:$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share:$HOME/.local/share:$XDG_DATA_DIRS";
  };
}
