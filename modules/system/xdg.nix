{ config, pkgs, lib, inputs, ... }:
{
  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gnome
      ];
      config = {
        niri = {
          default = [
            "gnome"
            "gtk"
          ];
          "org.freedesktop.impl.portal.Secret" = [
            "gnome-keyring"
          ];
        };
        common.default = [
          "gnome"
        ];
      };
    };
    mime = {
      enable = true;
      defaultApplications = {
        "image/png" = "viewnior.desktop";
        "image/jpeg" = "viewnior.desktop";
        "image/jpg" = "viewnior.desktop";
        "image/webp" = "viewnior.desktop";
        "video/mp4" = "mpv.desktop";
        "video/webm" = "mpv.desktop";
        "video/mkv" = "mpv.desktop";
        "video/mov" = "mpv.desktop";
        "video/mpeg" = "mpv.desktop";
        "video/mpg" = "mpv.desktop";
        "application/pdf" = "zathura.desktop";
        "inode/directory" = "thunar.desktop";
        "text/html" = "microsoft-edge.desktop";
        "x-scheme-handler/http" = "microsoft-edge.desktop";
        "x-scheme-handler/https" = "microsoft-edge.desktop";
        "application/x-mswinurl" = "microsoft-edge.desktop";
        "text/plain" = "org.kde.kate.desktop";
        "text/markdown" = "org.kde.kate.desktop";
        "application/zip" = "org.kde.ark.desktop";
        "application/x-7z-compressed" = "org.kde.ark.desktop";
        "application/x-compressed-tar" = "org.kde.ark.desktop";
        "application/x-xz-compressed-tar" = "org.kde.ark.desktop";
        "application/x-tar" = "org.kde.ark.desktop";
        "application/x-rar" = "org.kde.ark.desktop";
        "application/vnd.rar" = "org.kde.ark.desktop";
        "application/gzip" = "org.kde.ark.desktop";
        "application/x-bzip2" = "org.kde.ark.desktop";
        "application/json" = "org.kde.kate.desktop";
        "audio/aac" = "mpv.desktop";
        "audio/mp4" = "mpv.desktop";
        "audio/mpeg" = "mpv.desktop";
        "audio/mpegurl" = "mpv.desktop";
        "audio/ogg" = "mpv.desktop";
        "audio/vorbis" = "mpv.desktop";
        "audio/x-flac" = "mpv.desktop";
        "audio/x-mp3" = "mpv.desktop";
        "audio/x-mpegurl" = "mpv.desktop";
        "audio/x-ms-wma" = "mpv.desktop";
        "audio/x-wav" = "mpv.desktop";
      };
    };
  };
}
