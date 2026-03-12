{ config, pkgs, inputs, ... }:
let
  osuLazerLatest = pkgs.callPackage ../../files/packages/osuLazerLatest.nix { };
  epdfinfoPkg = pkgs.callPackage ../../files/packages/epdfinfo/default.nix { };
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
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
    nickel
    epdfinfoPkg
    libelf
    gnumake
    gcc
    inputs.nix-alien.packages.${pkgs.stdenv.hostPlatform.system}.nix-alien
    inputs.nix-search-tv.packages.x86_64-linux.default
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    emacs-wayland
    emacs-x11
    irssi
    home-manager
    osuLazerLatest
  ];
}
