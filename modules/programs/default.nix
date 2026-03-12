{ config, pkgs, inputs, ... }:
{
  imports = [
    ./zsh.nix
    ./tmux.nix
  ];
}
