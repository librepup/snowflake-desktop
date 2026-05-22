{ config, pkgs, lib, inputs, ... }:
{
  services = {
    usbmuxd = {
      enable = true;
      group = "usbmux";
    };
  };
}
