{ config, pkgs, lib, inputs, unstable, ... }:
{
  programs.mpv = {
    enable = true;
    config = {
      volume = 50;
      force-window = true;
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
      WHEEL_UP = "add volume 5";
      WHEEL_DOWN = "add volume -5";
      WHEEL_LEFT = "playlist-prev";
      WHEEL_RIGHT = "playlist-next";
      "Shift+WHEEL_UP" = "add volume 1";
      "Shift+WHEEL_DOWN" = "add volume -1";
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
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
