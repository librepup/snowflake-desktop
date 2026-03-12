{ config, pkgs, inputs, ... }:
{
  programs.ydotool = {
    enable = true;
    group = "ydotool";
  };
  services.input-remapper = {
    enable = true;
  };
  hardware.opentabletdriver = {
    enable = true;
  };
  hardware.uinput.enable = true;
  boot.kernelModules = [ "uinput" ];
  services.udev = {
    packages = [ pkgs.util-linux ];
    extraRules = ''
      # Wacom CTH-480 for OpenTabletDriver (OTD)
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="056a", ATTRS{idProduct}=="0302", MODE="0666", GROUP="plugdev"
    '';
  };
}
