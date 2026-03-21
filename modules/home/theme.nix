{ config, lib, pkgs, inputs, unstable, ... }:
{
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "XCursor-Pro-Red";
    size = 28;
  };
  gtk = {
    enable = true;
    theme = {
      name = lib.mkForce "Chicago95";
      #package = lib.mkForce (pkgs.runCommand "chicago95-gtk-only" {} ''
      #  mkdir -p $out/share/themes/Chicago95
      #  cp -rH ${pkgs.chicago95}/share/themes/Chicago95/* $out/share/themes/Chicago95/
      #  chmod -R +w $out/share/themes/Chicago95
      #'');
      package = pkgs.chicago95;
      #package = lib.mkForce "${pkgs.chicago95}/share/themes/Chicago95";
      #name = lib.mkForce "WhiteSur-Dark";
      #package = lib.mkForce pkgs.whitesur-gtk-theme;
    };
    iconTheme = {
      name = lib.mkForce "Chicago95";
      package = lib.mkForce pkgs.chicago95;
      #name = lib.mkForce "WhiteSur-dark";
      #package = lib.mkForce pkgs.whitesur-icon-theme;
    };
    cursorTheme = {
      name = "XCursor-Pro-Red";
      package = pkgs.xcursor-pro;
      size = 28;
    };
  };
  stylix = {
    targets.gtk.enable = false;
    cursor = {
      name = "XCursor-Pro-Red";
      package = pkgs.xcursor-pro;
      size = 28;
    };
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
  };
}
