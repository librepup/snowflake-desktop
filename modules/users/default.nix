{ config, pkgs, inputs, ... }:
{
  imports = [
    ./generic.nix
    ./puppy.nix
    ./glenda.nix
  ];
}
