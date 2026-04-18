{ config, lib, pkgs, inputs, ... }:
{
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOLLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };
  programs.gamemode = {
    enable = true;
  };
  programs.steam = {
    enable = true;
    package = inputs.millennium.packages.x86_64-linux.millennium-steam;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    protontricks.enable = true;
  };
}
