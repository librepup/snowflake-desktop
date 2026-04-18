{ config, pkgs, inputs, unstable, lib, ... }:
{
  programs.aeroshell = {
    enable = true;
    polkit.enable = true;
    aerothemeplasma = {
      enable = true;
      sddm.enable = true;
    };
  };
}
