{ config, lib, pkgs, inputs, unstable, ... }:
{
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "XCursor-Pro-Dark";
    size = 28;
  };
  gtk = {
    theme = {
      name = lib.mkForce "WhiteSur-Dark";
      package = lib.mkForce pkgs.whitesur-gtk-theme;
    };
    iconTheme = {
      name = lib.mkForce "WhiteSur-dark";
      package = lib.mkForce pkgs.whitesur-icon-theme;
    };
    cursorTheme = {
      name = "XCursor-Pro-Dark";
      package = pkgs.xcursor-pro;
      size = 28;
    };
  };
  stylix = {
    cursor = {
      name = "XCursor-Pro-Dark";
      package = pkgs.xcursor-pro;
      size = 28;
    };
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
  };
}
