{ config, pkgs, lib, inputs, unstable, ... }:
{
  home = {
    username = "root";
    homeDirectory = "/root";
    stateVersion = "25.05";
  };
  nixMacs = {
    enable = true;
    themes = {
      fuwamoco = false;
      marnie = false;
      gruvbox = false;
      templeos = false;
      guix = false;
      jungle = false;
      jungleVibrant = true;
      cappuccinoNoir = false;
      installAll = true;
    };
    exwm = {
      enable = false;
    };
    waylandPackage.enable = true;
  };
}
