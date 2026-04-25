{ config, pkgs, lib, inputs, ... }:
{
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
