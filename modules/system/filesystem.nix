{ config, pkgs, lib, inputs, ... }:
{
  systemd.tmpfiles.rules = [
    "d /extra 0775 puppy users -"
    "d /extra/Files 0775 puppy users -"
    "d /mnt 0775 puppy users -"
    "d /mnt/SteamLibrary 0775 puppy users -"
    "d /run/nvidia-xdriver 0777 root root -"
    "d /mountables 0755 root root -"
    "d /mountables/genesis 0755 root root -"
    "d /mountables/exodus 0755 root root -"
    "d /mountables/leviticus 0755 root root -"
    "d /mountables/deuteronomy 0755 root root -"
    "d /mountables/ezekiel 0755 root root -"
    "d /mnt/Flatpak 0775 puppy users -"
    "d /mnt/Flatpak/app 0775 puppy users -"
    "d /mnt/Flatpak/varLib 0775 puppy users -"
    "d /mnt/Flatpak/localShare 0775 puppy users -"
  ];
  # Handle "/mnt"
  fileSystems."/mnt" = {
    device = "/dev/disk/by-uuid/a30aac38-dff9-45ca-9719-d8455016d774";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
    ];
  };
  fileSystems."/var/lib/flatpak" = {
    device = "/mnt/Flatpak/varLib";
    options = [ "bind" ];
    depends = [ "/mnt" ];
  };
  fileSystems."/home/puppy/.var/app" = {
    device = "/mnt/Flatpak/app";
    options = [ "bind" ];
    depends = [ "/mnt" ];
  };
  fileSystems."/home/puppy/.local/share/flatpak" = {
    device = "/mnt/Flatpak/localShare";
    options = [ "bind" ];
    depends = [ "/mnt" ];
  };
  environment.etc."flatpak/installations.d/extra.conf" = {
    text = ''
      [Installation "extra"]
      Path=/mnt/Flatpak/data/
      DisplayName=Extra Mount
      StorageType=harddisk
    '';
  };
  # Handle "/extra"
  fileSystems."/extra" = {
    device = "/dev/disk/by-uuid/f506870d-1913-4368-80ec-3f0af6103e99";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
    ];
  };
  # Waydroid Bind-Mount
  fileSystems."/home/puppy/.local/share/waydroid" = {
    device = "/mnt/Waydroid";
    options = [ "bind" ];
  };
}
