{ config, pkgs, inputs, lib, ... }:
{
  programs = {
    mango.enable = true;
    naitre.enable = true;
    xwayland.enable = true;
    niri.enable = true;
    dank-material-shell = {
      enable = true;
      quickshell.package = pkgs.unstable.quickshell;
      dgop.package = inputs.dgop.packages.${pkgs.system}.default;
    };
  };
}
