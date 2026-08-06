{ config, lib, pkgs, inputs, unstable, ... }:
{
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    name = "Amiga (Classic Red)";
    package = inputs.jonabron.packages.x86_64-linux.amiga-classic-red;
    size = 56;
    # name = "XCursor-Pro-Red";
    # package = pkgs.xcursor-pro;
    # size = 28;
  };
  programs.gnome-shell = {
    enable = true;
    extensions = with pkgs.gnomeExtensions; [
      {
        package = focus;
      }
      {
        package = auto-move-windows;
      }
      {
        package = moveclock;
      }
      {
        package = hide-activities-button;
      }
      {
        package = paperwm;
      }
      {
        package = user-themes;
      }
    ];
  };
  dconf = {
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "focus@scaryrawr.github.io"
          "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
          "blur-my-shell@aunetx"
          "Hide_Activities@shay.shayel.org"
          "moveclock@kuvaus.org"
          "paperwm@paperwm.github.com"
          "user-theme@gnome-shell-extensions.gcampax.github.com"
        ];
      };
      "org/gnome/desktop/wm/keybindings" = {
        close = [
          "<Alt><Shift>q"
        ];
        move-to-workspace-1 = [
          "<Alt><Shift>1"
        ];
        move-to-workspace-2 = [
          "<Alt><Shift>2"
        ];
        move-to-workspace-3 = [
          "<Alt><Shift>3"
        ];
        move-to-workspace-4 = [
          "<Alt><Shift>4"
        ];
        move-to-workspace-5 = [
          "<Alt><Shift>5"
        ];
        move-to-workspace-6 = [
          "<Alt><Shift>6"
        ];
        move-to-workspace-7 = [
          "<Alt><Shift>7"
        ];
        move-to-workspace-8 = [
          "<Alt><Shift>8"
        ];
        move-to-workspace-9 = [
          "<Alt><Shift>9"
        ];
        switch-to-workspace-1 = [
          "<Alt>1"
        ];
        switch-to-workspace-2 = [
          "<Alt>2"
        ];
        switch-to-workspace-3 = [
          "<Alt>3"
        ];
        switch-to-workspace-4 = [
          "<Alt>4"
        ];
        switch-to-workspace-5 = [
          "<Alt>5"
        ];
        switch-to-workspace-6 = [
          "<Alt>6"
        ];
        switch-to-workspace-7 = [
          "<Alt>7"
        ];
        switch-to-workspace-8 = [
          "<Alt>8"
        ];
        switch-to-workspace-9 = [
          "<Alt>9"
        ];
        toggle-fullscreen = [
          "<Alt><Shift>t"
        ];
      };
      "org/gnome/shell/keybindings" = {
        switch-to-application-1 = [];
        switch-to-application-2 = [];
        switch-to-application-3 = [];
        switch-to-application-4 = [];
        switch-to-application-5 = [];
      };
      "org/gnome/desktop/wm/preferences" = {
        mouse-button-modifier = "<Alt>";
        resize-with-right-button = true;
        focus-mode = "sloppy";
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        screensaver = [];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Alt><Shift>Return";
        command = "kitty";
        name = "term";
      };
      "org/gnome/mutter" = {
        edge-tiling = false;
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };
  gtk = {
    enable = true;
    colorScheme = lib.mkForce "dark";
    theme = {
      name = lib.mkForce "WhiteSur-Dark";
      package = lib.mkForce pkgs.whitesur-gtk-theme;
    };
    iconTheme = {
      name = lib.mkForce "WhiteSur-dark";
      package = lib.mkForce pkgs.whitesur-icon-theme;
    };
    cursorTheme = {
      name = "Amiga (Classic Red)";
      package = inputs.jonabron.packages.x86_64-linux.amiga-classic-red;
      size = 56;
      # name = "XCursor-Pro-Red";
      # package = pkgs.xcursor-pro;
      # size = 28;
    };
    gtk4 = {
      enable = true;
      colorScheme = lib.mkForce "dark";
      theme = {
        name = "Colloid-Dark";
        package = lib.mkForce pkgs.colloid-gtk-theme;
      };
    };
  };
  stylix = {
    targets.gtk.enable = false;
    cursor = {
      name = "Amiga (Classic Red)";
      package = inputs.jonabron.packages.x86_64-linux.amiga-classic-red;
      size = 56;
      # name = "XCursor-Pro-Red";
      # package = pkgs.xcursor-pro;
      # size = 28;
    };
    enable = false;
    image = ../../files/pictures/wallpapers/MoriCalliope/06.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
  };
}
