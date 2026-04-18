{ config, pkgs, inputs, ... }:
{
  services.guix = {
    enable = true;
    substituters = {
      urls = [
        "https://bordeaux.guix.gnu.org"
        "https://ci.guix.gnu.org"
        "https://berlin.guix.gnu.org"
        "https://substitutes.nonguix.org"
      ];
    };
  };
}
