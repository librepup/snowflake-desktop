{ config, pkgs, lib, inputs, ... }:
{
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            rightshift = "leftmeta";
            capslock = "leftcontrol";
          };
        };
      };
    };
  };
  environment.etc."keyd/config.conf".text = ''
    [ids]
    *

    [main]
    rightshift = leftmeta
    capslock = leftcontrol
  '';
}
