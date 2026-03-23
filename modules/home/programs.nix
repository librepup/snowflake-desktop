{ config, pkgs, lib, inputs, unstable, ... }:
{
  programs.mpv = {
    enable = true;
    config = {
      volume = 50;
      force-window = false;
      "autofit-larger" = "75%x75%";
      "image-display-duration" = "inf";
      "hr-seek" = true;
      "loop-playlist" = "inf";
      "loop-file" = "inf";
    };
    bindings = {
      n = "playlist-next";
      p = "playlist-prev";
      "Shift+Enter" = "playlist-next";
      PGDWN = "playlist-next";
      PGUP = "playlist-prev";
      "Shift+p" = "show-text $\{playlist\}";
      UP = "add volume 5";
      DOWN = "add volume -5";
      WHEEL_UP = "add volume 2";
      WHEEL_DOWN = "add volume -2";
      WHEEL_LEFT = "add volume -2";
      WHEEL_RIGHT = "add volume 2";
      d = "set volume 50";
      RIGHT = "seek 5";
      LEFT = "seek -5";
      "Shift+RIGHT" = "seek 1";
      "Shift+LEFT" = "seek -1";
      "Ctrl+RIGHT" = "add speed 0.1";
      "Ctrl+LEFT" = "add speed -0.1";
      "]" = "add audio-delay 0.100";
      "[" = "add audio-delay -0.100";
      r = "no-osd cycle video-rotate 90";
      R = "no-osd cycle video-rotate -90";
      q = "quit";
      "+" = "add video-zoom 0.1";
      "_" = "add video-zoom -0.1";
      "=" = "set video-zoom 0";
      "," = "frame-back-step";
      "." = "frame-step";
      "META+LEFT" = "add video-pan-x 0.1";
      "META+RIGHT" = "add video-pan-x -0.1";
      "META+UP" = "add video-pan-y 0.1";
      "META+DOWN" = "add video-pan-y -0.1";
    };
  };
  programs.alacritty = {
    enable = true;
    settings = {
      general = {
        live_config_reload = true;
      };
      colors = {
        #primary = {
        #  foreground = "#c5c8c6";
        #  background = "#1d1f21";
        #};
        #cursor = {
        #  text = "#1d1f21";
        #  cursor = "#ffffff";
        #};
        #normal = {
        #  black = "#1d1f21";
        #  red = "#cc6666";
        #  green = "#b5bd68";
        #  yellow = "#e6c547";
        #  blue = "#81a2be";
        #  magenta = "#b294bb";
        #  cyan = "#70c0ba";
        #  white = "#373b41";
        #};
        #bright = {
        #  black = "#665c54";
        #  red = "#ff3334";
        #  green = "#9ec400";
        #  yellow = "#f0c674";
        #  blue = "#81a2be";
        #  magenta = "#b77ee0";
        #  cyan = "#54ced6";
        #  white = "#282a2e";
        #};
      };
      font = lib.mkForce {
        offset = {
          x = 0;
          y = 0;
        };
        normal = {
          family = "DejaVu Sans Mono";
          style = "Regular";
        };
        size = 14;
      };
      cursor.style = {
        shape = "Beam";
        blinking = "Off";
      };
      window.padding = {
        x = 5;
        y = 5;
      };
    };
  };
  #programs.kitty = {
  #  enable = true;
  #};
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
