{ config, pkgs, lib, inputs, ... }:
{
  services.clamav = {
    updater = {
      enable = true;
    };
  };
}
