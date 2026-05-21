{ config, pkgs, inputs, ... }:
{
  services.ratbagd = {
    enable = true;
  };
}
