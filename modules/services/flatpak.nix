{ config, pkgs, inputs, ... }:
{
  services.flatpak = {
    enable = true;
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      "appcenter" = "https://flatpak.elementary.io/repo";
    };
    packages = [
      "flathub:app/com.pixelomer.ShijimaQt/x86_64/stable"
      "flathub:app/org.vinegarhq.Sober/x86_64/stable"
      "flathub:app/com.humatarayici.od/x86_64/stable"
      "flathub:app/org.garudalinux.firedragon/x86_64/stable"
      "flathub:app/com.github.PintaProject.Pinta/x86_64/stable"
      "flathub:app/com.opera.opera-gx"
    ];
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
