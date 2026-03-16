{ config, pkgs, lib, inputs, ... }:
{
  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      discord-container = {
        executable = "${pkgs.discord}/bin/discord";
        profile = "${pkgs.firejail}/etc/firejail/discord.profile";
        extraArgs = [
          "--x11=xephyr"
          "--xephyr-screen=2560x1422"
        ];
      };
    };
  };
}
