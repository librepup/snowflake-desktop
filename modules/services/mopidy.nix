{ config, pkgs, lib, inputs, ... }:
{
  services.mopidy = let
    mopidyPackagesOverride = pkgs.mopidyPackages.overrideScope (prev: final: {
      extraPkgs = pkgs: [ pkgs.yt-dlp ];
    });
  in {
    enable = true;
    extensionPackages = with mopidyPackagesOverride; [
      mopidy-youtube
      mopidy-notify
      mopidy-spotify
      mopidy-bandcamp
      mopidy-soundcloud
    ];
    configuration = ''
      [youtube]
      youtube_dl_package = yt_dlp
    '';
  };
  systemd.services.mopidy.wantedBy = lib.mkForce [ ];
}
