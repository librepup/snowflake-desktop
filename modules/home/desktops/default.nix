{ config, pkgs, lib, inputs, unstable, ... }:
{
  imports = [
    ./mango.nix
    ./naitre.nix
    ./others.nix
  ];
}
