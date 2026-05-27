{ config, pkgs, inputs, ... }:
{
  imports = [
    ./phone.nix
    ./zsh.nix
    ./tmux.nix
    ./spicetify.nix
    ./bash.nix
    ./steam.nix
    ./firefox.nix
    ./others.nix
    ./wayland.nix
    ./thunar.nix
    ./qt.nix
    # ./obs.nix
    # ./aeroshell.nix
  ];
}
