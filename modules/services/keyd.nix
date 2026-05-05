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
          };
        };
      };
    };
  };
  environment.etc."keyd/rShiftToSuper.conf".text = ''
    [ids]
    *

    [main]
    rightshift = leftmeta
  '';
}
