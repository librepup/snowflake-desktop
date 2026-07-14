{ config, pkgs, inputs, ... }:
{
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 10;
  };
}
