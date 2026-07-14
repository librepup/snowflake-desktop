{ config, pkgs, lib, inputs, ... }:
{
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };
}
