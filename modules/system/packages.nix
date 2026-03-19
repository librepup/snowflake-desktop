{ config, pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs;
  let
    emacs-wayland = pkgs.writeShellScriptBin "emacs-wayland" ''
      exec ${pkgs.emacs.override { withPgtk = true; }}/bin/emacs "$@"
    '';
    emacs-x11 = pkgs.writeShellScriptBin "emacs-x11" ''
      exec ${pkgs.emacs}/bin/emacs "$@"
    '';
  in
  [
    eza
    bat
    zoxide
    rsync
    nickel
    inputs.jonabron.packages.x86_64-linux.epdfinfo
    libelf
    gnumake
    gcc
    inputs.nix-alien.packages.${pkgs.stdenv.hostPlatform.system}.nix-alien
    inputs.nix-search-tv.packages.x86_64-linux.default
    vim
    wget
    emacs-wayland
    emacs-x11
    irssi
    home-manager
    inputs.jonabron.packages.x86_64-linux.osu-lazer-appimage
  ];
}
