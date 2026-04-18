{ config, pkgs, lib, inputs, unstable, ... }:
{
  imports = [
    ../default.nix
  ];
  home = {
    username = "puppy";
    homeDirectory = "/home/puppy";
    stateVersion = "25.05";
    sessionVariables = {
      XDG_DATA_DIRS = "$HOME/.guix-profile/share:$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share:$HOME/.local/share:$XDG_DATA_DIRS";
    };
    activation = {
      createXMonadSymLink = lib.hm.dag.entryAfter ["writeBoundary"] ''
        $DRY_RUN_CMD mkdir -p "$HOME/.xmonad"
        $DRY_RUN_CMD ln -sfn "/etc/nixos/files/config/xmonad/lib" "$HOME/.xmonad/lib"
        $DRY_RUN_CMD ln -sfn "/etc/nixos/files/config/xmonad/xmonad.hs" "$HOME/.xmonad/xmonad.hs"
      '';
      createPodManStorageConfigSymLink = lib.hm.dag.entryAfter ["writeBoundary"] ''
        $DRY_RUN_CMD mkdir -p "$HOME/.config/containers"
        $DRY_RUN_CMD ln -sfn "/etc/nixos/files/config/containers/storage.conf" "$HOME/.config/containers/storage.conf"
      '';
      createKittyConfigSymLink = lib.hm.dag.entryAfter ["writeBoundary"] ''
        $DRY_RUN_CMD mkdir -p "$HOME/.config/kitty"
        $DRY_RUN_CMD ln -sfn "/etc/nixos/files/config/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
      '';
    };
  };
}
