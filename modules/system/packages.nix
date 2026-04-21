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
    sddmBackground = pkgs.stdenvNoCC.mkDerivation {
      name = "sddmBackground";
      src = ../../files/pictures/wallpapers/MoriCalliope/06.png;
      dontUnpack = true;
      installPhase = ''
        cp $src $out
      '';
    };
  in
  [
    direnv
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
    (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background = "${sddmBackground}"
      DisplayServer=wayland
      DefaultSession=none+xmonad.desktop
      GreeterEnvironment=QT_WAYLAND_SHELL_INTEGRATION=layer-shell
      HaltCommand=/run/current-system/systemd/bin/systemctl poweroff
      RebootCommand=/run/current-system/systemd/bin/systemctl reboot
      InputMethod=
      Numlock=none

      [Theme]
      Current=breeze
      CursorSize=24
      FacesDir=/run/current-system/sw/share/sddm/faces
      ThemeDir=/run/current-system/sw/share/sddm/themes

      [Users]
      HideShells=/run/current-system/sw/bin/nologin
      HideUsers=nixbld1,nixbld10,nixbld11,nixbld12,nixbld13,nixbld14,nixbld15,nixbld16,nixbld17,nixbld18,nixbld19,nixbld2,nixbld20,nixbld21,nixbld22,nixbld23,nixbld24,nixbld25,nixbld26,nixbld27,nixbld28,nixbld29,nixbld3,nixbld30,nixbld31,nixbld32,nixbld4,nixbld5,nixbld6,nixbld7,nixbld8,nixbld9,glenda
      MaximumUid=30000
    '')
  ];
}
