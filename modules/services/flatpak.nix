{ config, pkgs, inputs, lib, ... }:
{
  services.flatpak = {
    enable = true;
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    };
    packages = [
      "flathub:app/com.pixelomer.ShijimaQt/x86_64/stable"
      "flathub:app/org.vinegarhq.Sober/x86_64/stable"
      "flathub:app/com.humatarayici.od/x86_64/stable"
      "flathub:app/org.garudalinux.firedragon/x86_64/stable"
      "flathub:app/com.github.PintaProject.Pinta/x86_64/stable"
      "flathub:app/com.opera.opera-gx/x86_64/stable"
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
  systemd.services.manage-flatpaks-activation = {
    enable = true;
    serviceConfig = {
      Restart = lib.mkForce "no";
      RestartPreventExitStatus = "1";
    };
    unitConfig.DefaultDependencies = "no";
    wantedBy = [ "multi-user.target" ];
    stopIfChanged = false;
  };
}
