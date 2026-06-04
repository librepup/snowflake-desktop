{ config, pkgs, inputs, ... }:
{
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      inputs.jonabron.packages.x86_64-linux.gnutypewriter-font
      inputs.jonabron.packages.x86_64-linux.cartographcf-font
      inputs.jonabron.packages.x86_64-linux.jonafonts.synapsian
      inputs.jonabron.packages.x86_64-linux.jonafonts.karamarea
      inputs.jonabron.packages.x86_64-linux.jonafonts.templeos
      inputs.jonabron.packages.x86_64-linux.jonafonts.icons
      inputs.jonabron.packages.x86_64-linux.jonafonts.lucidabright
      inputs.jonabron.packages.x86_64-linux.jonafonts.blexmono
      inputs.jonabron.packages.x86_64-linux.jonafonts.w95fa
      corefonts
      dejavu_fonts
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
      nerd-fonts.go-mono
      tt2020
      emacs-all-the-icons-fonts
      julia-mono
      vista-fonts
    ];
  };
}
