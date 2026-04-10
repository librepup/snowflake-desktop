{ config, lib, pkgs, inputs, ... }:
{
  nixpkgs.overlays = [
    (self: super: {
      xfce = super.xfce // {
        thunar = let
          thunarUnwrapped = super.xfce.thunar.overrideAttrs (oldAttrs: {
            configureFlags = (oldAttrs.configureFlags or []) ++ [ "--disable-wallpaper-plugin" ];
          });
          thunarDir = builtins.dirOf super.xfce.thunar.meta.position;
        in
        super.callPackage "${thunarDir}/wrapper.nix" {
          thunar-unwrapped = thunarUnwrapped;
          thunarPlugins = with super.xfce; [
            thunar-media-tags-plugin
            thunar-archive-plugin
            thunar-volman
          ];
        };
      };
    })
  ];
  programs = {
    thunar = {
      enable = true;
    };
    xfconf = {
      enable = true;
    };
  };
  services = {
    gvfs.enable = true;
    tumbler.enable = true;
    dbus.packages = [ pkgs.xfce.thunar ];
  };
  environment.variables = {
    THUNARX_MODULE_DIR = "${pkgs.xfce.thunar-archive-plugin}/lib/thunarx-3";
  };
}
