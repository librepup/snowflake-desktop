{ config, pkgs, lib, inputs, ... }:
{
  xdg = {
    mime = {
      enable = true;
      defaultApplications = {
        "image/png" = "feh.desktop";
        "image/jpeg" = "feh.desktop";
        "image/jpg" = "feh.desktop";
        "image/webp" = "feh.desktop";
        "video/mp4" = "mpv.desktop";
        "video/webm" = "mpv.desktop";
        "video/mkv" = "mpv.desktop";
        "video/mov" = "mpv.desktop";
        "video/mpeg" = "mpv.desktop";
        "video/mpg" = "mpv.desktop";
        "application/pdf" = "zathura.desktop";
        "inode/directory" = "thunar.desktop";
        "text/html" = "helium.desktop";
        "x-scheme-handler/http" = "helium.desktop";
        "application/x-mswinurl" = "helium.desktop";
        "text/plain" = "org.gnome.TextEditor.desktop";
        "text/markdown" = "org.gnome.TextEditor.desktop";
        "application/zip" = "org.kde.ark.desktop";
        "application/x-7z-compressed" = "org.kde.ark.desktop";
        "application/x-compressed-tar" = "org.kde.ark.desktop";
        "application/x-xz-compressed-tar" = "org.kde.ark.desktop";
        "application/vnd.rar" = "org.kde.ark.desktop";
      };
    };
  };
}
