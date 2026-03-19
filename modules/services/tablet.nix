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
  systemd.user.services.input-remapper-autoload = {
    description = "Input-Remapper Autoload Service";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.input-remapper}/bin/input-remapper-control --config-dir ${config.users.users.puppy.home}/.my-input-remappings/tablet --command autoload";
    };
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
