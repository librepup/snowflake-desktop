{ config, pkgs, inputs, ... }:
{
  boot.loader = {
    timeout = 30;
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = false;
    grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
      theme = inputs.jonabron.packages.x86_64-linux.dangerousjungle-grub-theme;
      gfxmodeEfi = "1920x1080";
      gfxpayloadEfi = "keep";
      configurationLimit = 10;
    };
  };
  specialisation = {
    rescue-mode.configuration = {
      system.nixos.tags = [ "rescue" ];
      boot.kernelParams = [ "systemd.unit=rescue.target" ];
    };
  };
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;
}
