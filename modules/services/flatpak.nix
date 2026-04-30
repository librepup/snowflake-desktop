{ config, pkgs, inputs, ... }:
{
  services.flatpak = {
    enable = true;
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      "appcenter" = "https://flatpak.elementary.io/repo";
    };
    packages = [
      "flathub:com.pixelomer.ShijimaQt"
      "flathub:org.vinegarhq.Sober"
      "flathub:com.humatarayici.od"
      "flathub:org.garudalinux.firedragon"
      "flathub:com.github.PintaProject.Pinta"
      "flathub:com.opera.opera-gx"
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
