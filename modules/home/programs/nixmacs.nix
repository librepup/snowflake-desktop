{ config, pkgs, lib, inputs, unstable, ... }:
{
  nixMacs = {
    enable = true;
    themes = {
      fuwamoco = false;
      marnie = false;
      gruvbox = false;
      templeos = false;
      guix = false;
      jungle = false;
      jungleVibrant = false;
      cappuccinoNoir = false;
      filian = true;
      installAll = true;
    };
    exwm = {
      enable = true;
      layout = "colemak";
    };
    wayland = {
      enable = true;
      separatePackage = true;
    };
  };
}
