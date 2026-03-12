{ config, pkgs, inputs, ... }:
{
  imports = [
    ./system/default.nix
    ./programs/default.nix
    ./services/default.nix
    ./users/default.nix
  ];
}
