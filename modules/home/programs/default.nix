{ config, pkgs, lib, unstable, ... }:
{
  imports = [
    #./direnv.nix
    ./keepassxc.nix
    ./music.nix
    ./nixmacs.nix
    ./others.nix
    ./vim.nix
  ];
}
