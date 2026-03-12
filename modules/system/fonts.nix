{ config, pkgs, inputs, ... }:
let
  synapsian = pkgs.callPackage ../../files/packages/synapsian/default.nix { };
  karamarea = pkgs.callPackage ../../files/packages/karamarea/default.nix { };
  templeos = pkgs.callPackage ../../files/packages/templeosFont/default.nix { };
  gnutypewriter = pkgs.callPackage ../../files/packages/gnutypewriter/default.nix { };
  epdfinfoPkg = pkgs.callPackage ../../files/packages/epdfinfo/default.nix { };
  cartographCF = pkgs.callPackage ../../files/packages/cartographCF/default.nix { };
in
{
  fonts = {
    packages = with pkgs; [
      cartographCF
      synapsian
      karamarea
      gnutypewriter
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji-blob-bin
      liberation_ttf
      fira-code
      fira-code-symbols
      dina-font
      proggyfonts
      uw-ttyp0
      terminus_font
      terminus_font_ttf
      tamzen
      powerline-fonts
      twitter-color-emoji
      iosevka
      nerd-fonts.symbols-only
      maple-mono.truetype
      inputs.jonafonts.packages.${pkgs.stdenv.hostPlatform.system}.jonafonts
      tt2020 # Typewrite Font
      templeos
      emacs-all-the-icons-fonts # Required for Emacs all-the-icons
    ];
  };
}
