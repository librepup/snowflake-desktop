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
      font = "${pkgs.grub2}/share/grub/unicode.pf2";
      gfxmodeEfi = "1920x1080";
      gfxmodeBios = "1920x1080";
      gfxpayloadEfi = "keep";
      configurationLimit = 10;
      timeoutStyle = "menu";
      extraConfig = ''
        insmod all_video
        set terminal_output gfxterm
        set timeout=30
      '';
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
