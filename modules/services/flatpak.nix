{ config, pkgs, inputs, ... }:
{
  services.flatpak = {
    enable = true;
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      "appcenter" = "https://flatpak.elementary.io/repo";
    };
    flatpakDir = "/mnt/Flatpak/data";
    overrides = {
      "global".Context = {
        sockets = [
          "x11"
          "fallback-x11"
          "!wayland"
        ];
      };
    };
  };
}
