{ config, pkgs, inputs, lib, ... }:
{
  services.flatpak = {
    enable = true;
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    };
    packages = [
      "flathub:app/com.pixelomer.ShijimaQt/x86_64/stable" # Desktop Pets
      "flathub:app/org.vinegarhq.Sober/x86_64/stable" # Roblox
      # "flathub:app/com.humatarayici.od/x86_64/stable" # Hüma Browser
      # "flathub:app/org.garudalinux.firedragon/x86_64/stable" # FireDragon Browser
      "flathub:app/com.github.PintaProject.Pinta/x86_64/stable" # Paint.NET Alternative
      # "flathub:app/com.opera.opera-gx/x86_64/stable" # OperaGX Browser
      "flathub:app/io.github.Soundux/x86_64/stable" # Soundboard
      "flathub:app/com.github.tchx84.Flatseal/x86_64/stable" # Manage Flatpak Permissions
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
