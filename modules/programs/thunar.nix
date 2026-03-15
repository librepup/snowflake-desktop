{ config, lib, pkgs, inputs, ... }:
{
  programs = {
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-media-tags-plugin
        thunar-archive-plugin
      ];
    };
    xfconf = {
      enable = true;
    };
  };
}
