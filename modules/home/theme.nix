{ config, lib, pkgs, inputs, unstable, ... }:
{
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    name = "XCursor-Pro-Red";
    package = pkgs.xcursor-pro;
    size = 28;
  };
  #dconf.settings = {
  #  "org/gnome/desktop/interface" = {
  #    color-scheme = "prefer-dark";
  #  };
  #};
  gtk = {
    enable = true;
    theme = {
      # Diinki Aero
      #name = lib.mkForce "Diinki Aero";
      #package = inputs.jonabron.packages.x86_64-linux.diinki-aero;

      # Windows XP Luna
      #name = lib.mkForce "Windows XP Luna";
      #package = inputs.jonabron.packages.x86_64-linux.xptheme;

      # Chicago95
      #name = lib.mkForce "Chicago95";
      #package = pkgs.chicago95;

      # WhiteSur
      name = lib.mkForce "WhiteSur-Dark";
      package = lib.mkForce pkgs.whitesur-gtk-theme;
    };
    iconTheme = {
      # ReVista
      #name = lib.mkForce "ReVista";
      #package = lib.mkForce inputs.jonabron.packages.x86_64-linux.revista;

      # Chicago95
      name = lib.mkForce "Chicago95";
      package = lib.mkForce pkgs.chicago95;

      # WhiteSur
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
    enable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
  };
}
