{ config, pkgs, lib, inputs, unstable, ... }:
{
  services.vicinae = {
    enable = true; # default: false
    systemd = {
      enable = true; # default: false
      autoStart = true; # default: false
      environment = {
        USE_LAYER_SHELL = 1;
      };
    };
  };
  programs.noctalia-shell = {
    enable = true;
    package = inputs.noctalia.packages.${pkgs.system}.default;
  };
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        useGrimAdapter = true;
        disabledGrimWarning = true;
        savePath = "/home/puppy/Pictures/screenshots";
        saveAsFileExtension = ".png";
      };
    };
  };
}
