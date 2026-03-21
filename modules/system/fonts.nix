{ config, pkgs, inputs, ... }:
{
  fonts = {
    packages = with pkgs; [
      inputs.jonabron.packages.x86_64-linux.gnutypewriter-font
      inputs.jonabron.packages.x86_64-linux.cartographcf-font
      inputs.jonabron.packages.x86_64-linux.jonafonts.all
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
      tt2020
      emacs-all-the-icons-fonts
      julia-mono
      vista-fonts
    ];
  };
}
