{ config, pkgs, lib, inputs, ... }:
{
  programs.firejail = {
    enable = true;
  };
}
