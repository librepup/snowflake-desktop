{ config, pkgs, lib, inputs, unstable, ... }:
{
  qt = {
    enable = true;
    platformTheme.name = "kde";
    style.name = "kvantum";
  };
  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=Windows7Aero
  '';
  programs.plasma = {
    enable = true;
    workspace = {
      lookAndFeel = "authui7";
      theme = "Seven-Black";
      windowDecorations = {
        library = "org.kde.breeze";
        theme = "Breeze";
      };
    };
  };
]
