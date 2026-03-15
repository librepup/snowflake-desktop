{ config, pkgs, lib, inputs, unstable, ... }:
{
  xdg = {
    desktopEntries = {
      "nixmacs" = {
        name = "NixMacs";
        exec = "nixmacs %U";
        terminal = false;
        categories = [ "Development" "TextEditor" ];
        mimeType = [ "text/plain" ];
      };
      "nixmacs-wayland" = {
        name = "NixMacs Wayland";
        exec = "nixmacs-wayland %U";
        terminal = false;
        categories = [ "Development" "TextEditor" ];
        mimeType = [ "text/plain" ];
      };
      "kittycat" = {
        name = "KittyCat";
        genericName = "Terminal";
        exec = "kitty o font_family=TempleOS -o font_size=8 %U";
        terminal = false;
        categories = [ "System" "TerminalEmulator" ];
        type = "Application";
      };
    };
    terminal-exec = {
      enable = true;
      settings = {
        default = [ "kittycat.desktop" ];
      };
    };
  };
}
