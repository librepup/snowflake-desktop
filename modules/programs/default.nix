{ config, pkgs, inputs, ... }:
{
  imports = [
    ./zsh.nix
    ./tmux.nix
    ./spicetify.nix
    ./bash.nix
    ./steam.nix
    ./firefox.nix
    ./others.nix
    ./wayland.nix
    ./thunar.nix
  ];
}
