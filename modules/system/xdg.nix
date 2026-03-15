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
        "application/pdf" = "zathura.desktop";
        "inode/directory" = "thunar.desktop";
        "text/html" = "zen.desktop";
        "text/plain" = "nixmacs.desktop";
        "text/markdown" = "nixmacs.desktop";
      };
    };
  };
  environment = {
    variables = {
      EDITOR = "nixmacs";
      VISUAL = "nixmacs";
      PAGER = "less";
      TERMINAL = "kitty";
      HISTSIZE = 5000;
      HISTFILESIZE = 10000;
      HISTCONTROL = "ignoredups:erasedups";
    };
    interactiveShellInit = ''
      unset EMACSLOADPATH
    '';
  };
}
