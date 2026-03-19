{ config, pkgs, lib, inputs, unstable, ... }:
{
  imports = [
    ../default.nix
  ];
  home = {
    username = "puppy";
    homeDirectory = "/home/puppy";
    stateVersion = "25.05";
    sessionVariables = {
      XDG_DATA_DIRS = "$HOME/.guix-profile/share:$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share:$HOME/.local/share:$XDG_DATA_DIRS";
    };
  };
}
