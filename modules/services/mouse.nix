{ config, pkgs, inputs, ... }:
{
  services = {
    ratbagd = {
      enable = true;
    };
    hardware.openrgb = {
      enable = true;
      motherboard = "intel";
      server.port = 6742;
    };
  };
}
