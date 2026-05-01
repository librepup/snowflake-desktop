{ config, pkgs, lib, inputs, unstable, ... }:
{
  services.copyq = {
    enable = true;
  };
}
