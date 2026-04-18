{ config, pkgs, lib, unstable, ... }:
{
  imports = [
    #./direnv.nix
    ./music.nix
    ./nixmacs.nix
    ./others.nix
    ./vim.nix
  ];
}
