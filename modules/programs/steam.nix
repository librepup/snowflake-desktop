{ config, lib, pkgs, inputs, ... }:
{
  programs.steam = {
    enable = true;
    package = inputs.millennium.packages.x86_64-linux.millennium-steam;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
}
