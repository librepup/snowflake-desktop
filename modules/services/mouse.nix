{ config, pkgs, inputs, ... }:
{
  services = {
    ratbagd = {
      enable = true;
    };
    openrgb = {
      enable = true;
      motherboard = "intel";
      server.port = 6742;
    };
  };
}
