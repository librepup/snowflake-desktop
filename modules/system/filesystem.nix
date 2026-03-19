{ config, pkgs, lib, inputs, ... }:
{
  systemd.tmpfiles.rules = [
    "d /extra 0775 puppy users -"
    "d /mnt 0775 puppy users -"
    "d /mnt/SteamLibrary 0775 puppy users -"
    "d /run/nvidia-xdriver 0777 root root -"
    "d /mountables 0755 root root -"
    "d /mountables/genesis 0755 root root -"
    "d /mountables/exodus 0755 root root -"
    "d /mountables/leviticus 0755 root root -"
    "d /mountables/deuteronomy 0755 root root -"
    "d /mountables/ezekiel 0755 root root -"
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
  # Waydroid Bind-Mount
  fileSystems."/home/puppy/.local/share/waydroid" = {
    device = "/mnt/Waydroid";
    options = [ "bind" ];
  };
}
