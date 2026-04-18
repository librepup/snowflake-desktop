{ config, pkgs, lib, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  wmPotifySource = pkgs.fetchFromGitHub {
    owner = "Ingan121";
    repo = "WMPotify";
    rev = "d9492c7b55a2db21c2ef9f3643e2c00e370babd4";
    hash = "sha256-w3RTNiFLcWxADaqjlUy8sXKP92qtgmhovglZDAdA278=";
  };
in
{
  programs.spicetify = {
    enable = true;
    #theme = spicePkgs.themes.sleek;
    theme = {
      name = "WMPotify";
      src = "${wmPotifySource}/theme/dist";
      appendName = false;
      injectCss = true;
      replaceColors = true;
      overwriteAssets = true;
      sidebarConfig = true;
    };
    enabledExtensions = with spicePkgs.extensions; [
      {
        name = "theme.js";
        src = "${wmPotifySource}/theme/dist";
      }
    ];
    enabledCustomApps = [
      {
        name = "wmpvis";
        src = "${wmPotifySource}/CustomApps/wmpvis/dist";
      }
    ];
  };
}
