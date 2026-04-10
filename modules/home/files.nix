{ config, pkgs, inputs, lib, unstable, ... }:
{
  # EWW
  home.file.".config/eww/eww.yuck".source = ../../files/config/eww/eww.yuck;
  home.file.".config/eww/eww.scss".source = ../../files/config/eww/eww.scss;
  home.file.".config/eww/images/clock.png".source = ../../files/config/eww/images/clock.png;
  home.file.".config/eww/images/filian.gif".source = ../../files/config/eww/images/filian.gif;
  # Input Remaps
  home.file.".my-input-remappings/xbindkeys/global".source = ../../files/config/xbindkeys/global;
  home.file.".my-input-remappings/xmodmap/global".source = ../../files/config/xmodmap/global;
  # Thunar
  home.file.".config/gtk-3.0/bookmarks".source = ../../files/config/gtk-3.0/bookmarks;
  xdg.configFile."Thunar/uca.xml" = {
    source = ../../files/config/Thunar/uca.xml;
  };
  # Picom
  home.file.".config/picom/picom.conf".source = ../../files/config/picom/picom.conf;
  # Wofi
  home.file = {
    ".config/wofi/config".source = ../../files/config/wofi/config;
    ".config/wofi/style.css".source = ../../files/config/wofi/style.css;
    ".config/wofi/redstyle.css".source = ../../files/config/wofi/redstyle.css;
    ".config/wofi/guixstyle.css".source = ../../files/config/wofi/guixstyle.css;
  };
  # MPV
  home.file = {
    ".config/mpv/scripts/copy-time.lua".source = ../../files/config/mpv/scripts/copy-time.lua;
    ".config/mpv/scripts/cycle-commands.lua".source = ../../files/config/mpv/scripts/cycle-commands.lua;
    ".config/mpv/scripts/cycle-profile.lua".source = ../../files/config/mpv/scripts/cycle-profile.lua;
    ".config/mpv/scripts/modernz.lua".source = ../../files/config/mpv/scripts/modernz.lua;
    ".config/mpv/scripts/mpv-gif.lua".source = ../../files/config/mpv/scripts/mpv-gif.lua;
    ".config/mpv/scripts/playlistmanager.lua".source = ../../files/config/mpv/scripts/playlistmanager.lua;
    ".config/mpv/scripts/seek-to.lua".source = ../../files/config/mpv/scripts/seek-to.lua;
    ".config/mpv/scripts/sponsorblock-minimal.lua".source = ../../files/config/mpv/scripts/sponsorblock-minimal.lua;
    ".config/mpv/scripts/thumbfast.lua".source = ../../files/config/mpv/scripts/thumbfast.lua;
    ".config/mpv/fonts/fluent-system-icons.ttf".source = ../../files/config/mpv/fonts/fluent-system-icons.ttf;
    ".config/mpv/fonts/Netflix Sans Bold.otf".source = ../../files/config/mpv/fonts/Netflix_Sans_Bold.otf;
    ".config/mpv/fonts/Netflix Sans Light.otf".source = ../../files/config/mpv/fonts/Netflix_Sans_Light.otf;
    ".config/mpv/fonts/Netflix Sans Medium.otf".source = ../../files/config/mpv/fonts/Netflix_Sans_Medium.otf;
  };
  # Waybar
  home.file = {
    ".config/waybar/config.jsonc".source = ../../files/config/waybar/config.jsonc;
    ".config/waybar/style.css".source = ../../files/config/waybar/style.css;
    ".config/waybar/guix.css".source = ../../files/config/waybar/guix.css;
    ".config/waybar/jungle.css".source = ../../files/config/waybar/jungle.css;
    ".config/waybar/layout.jsonc".source = ../../files/config/waybar/layout.jsonc;
  };
  # ZSH Scripts and Functions
  home.file = {
    ".scripts/tagmp3.sh" = {
      source = ../../files/scripts/tagmp3.sh;
      executable = true;
    };
    ".scripts/polybar-date-toggle.sh" = {
      source = ../../files/scripts/polybar-date-toggle.sh;
      executable = true;
    };
    ".scripts/gfetch-linux-compat.rc" = {
      source = ../../files/scripts/gfetch-linux-compat.rc;
      executable = true;
    };
    ".scripts/nixmacs-wayland-run.sh" = {
      source = ../../files/scripts/nixmacs-wayland-run.sh;
      executable = true;
    };
    ".scripts/runRio.sh" = {
      source = ../../files/scripts/runRio.sh;
      executable = true;
    };
    # Completions (comps)
    ".shell-autoload-functions/comps/_g".source = ../../files/completions/_g;
    # Functions (funcs)
    ".shell-autoload-functions/funcs/translate.sh".source = ../../files/scripts/translate.sh;
    ".shell-autoload-functions/funcs/eww.sh".source = ../../files/scripts/eww.sh;
    ".shell-autoload-functions/funcs/serve.sh".source = ../../files/scripts/serve.sh;
    ".shell-autoload-functions/funcs/ports.sh".source = ../../files/scripts/ports.sh;
    ".shell-autoload-functions/funcs/nixgens.sh".source = ../../files/scripts/nixgens.sh;
    ".shell-autoload-functions/funcs/general-stuff.sh".source = ../../files/scripts/general-stuff.sh;
    ".shell-autoload-functions/funcs/nixclean.sh".source = ../../files/scripts/nixclean.sh;
    ".shell-autoload-functions/funcs/android.sh".source = ../../files/scripts/android.sh;
    ".shell-autoload-functions/funcs/play.sh".source = ../../files/scripts/play.sh;
    ".shell-autoload-functions/funcs/preexec.sh".source = ../../files/scripts/preexec.sh;
    ".shell-autoload-functions/funcs/nix-get-store-path.sh".source = ../../files/scripts/nix-get-store-path.sh;
    ".shell-autoload-functions/funcs/mp3.sh".source = ../../files/scripts/mp3.sh;
    ".shell-autoload-functions/funcs/help.sh".source = ../../files/scripts/help.sh;
    ".shell-autoload-functions/funcs/nixgethash.sh".source = ../../files/scripts/nixgethash.sh;
    ".shell-autoload-functions/funcs/keymon.sh".source = ../../files/scripts/keymon.sh;
    ".shell-autoload-functions/funcs/buildnix.sh".source = ../../files/scripts/buildnix.sh;
    ".shell-autoload-functions/funcs/cartom.sh".source = ../../files/scripts/cartom.sh;
    ".shell-autoload-functions/funcs/crypt.sh".source = ../../files/scripts/crypt.sh;
    ".shell-autoload-functions/funcs/disks.sh".source = ../../files/scripts/disks.sh;
    ".shell-autoload-functions/funcs/extract.sh".source = ../../files/scripts/extract.sh;
    ".shell-autoload-functions/funcs/fkill.sh".source = ../../files/scripts/fkill.sh;
    ".shell-autoload-functions/funcs/generators.sh".source = ../../files/scripts/generators.sh;
    ".shell-autoload-functions/funcs/git-helper.sh".source = ../../files/scripts/git-helper.sh;
    ".shell-autoload-functions/funcs/guix-manager-helper.sh".source = ../../files/scripts/guix-manager-helper.sh;
    ".shell-autoload-functions/funcs/hashurl.sh".source = ../../files/scripts/hashurl.sh;
    ".shell-autoload-functions/funcs/mp4.sh".source = ../../files/scripts/mp4.sh;
    ".shell-autoload-functions/funcs/nix-shell-prebuilds.sh".source = ../../files/scripts/nix-shell-prebuilds.sh;
    ".shell-autoload-functions/funcs/edit.sh".source = ../../files/scripts/edit.sh;
    ".shell-autoload-functions/funcs/nix-stuff.sh".source = ../../files/scripts/nix-stuff.sh;
    ".shell-autoload-functions/funcs/upload.sh".source = ../../files/scripts/upload.sh;
    ".scripts/waybar.sh" = {
      source = ../../files/scripts/waybar.sh;
      executable = true;
    };
    ".scripts/record.sh" = {
      source = ../../files/scripts/record.sh;
      executable = true;
    };
    ".scripts/flameshotCopyToClip.sh" = {
      source = ../../files/scripts/flameshotCopyToClip.sh;
      executable = true;
    };
  };
  # FastFetch Config
  home.file.".shell-autoload-functions/funcs/ff.sh".source = ../../files/scripts/ff.sh;
  home.file.".config/fastfetch/images/gigi.png".source = ../../files/config/fastfetch/gigi.png;
  home.file.".config/fastfetch/config.jsonc".source = ../../files/config/fastfetch/config.jsonc;
  # Discord Colorscheme
  home.file.".config/vesktop/themes/dank.css".source = ../../files/config/discord/dank.css;
  home.file.".config/vesktop/themes/guix.css".source = ../../files/config/discord/guix.css;
  home.file.".config/vesktop/themes/fuwamoco-theme.css".source = ../../files/config/discord/fuwamoco-theme.css;
  # Kitty Colorschemes
  home.file = {
    ".config/kitty/kitty.conf".source = ../../files/config/kitty/kitty.conf;
    ".config/kitty/scripts/emacsPager.sh" = {
      source = ../../files/config/kitty/scripts/emacsPager.sh;
      executable = true;
    };
    ".config/kitty/themes/fuwamocoColorscheme.conf".source = ../../files/config/kitty/themes/fuwamocoColorscheme.conf;
    ".config/kitty/themes/marnieColorscheme.conf".source = ../../files/config/kitty/themes/marnieColorscheme.conf;
    ".config/kitty/themes/guixColorscheme.conf".source = ../../files/config/kitty/themes/guixColorscheme.conf;
    ".config/kitty/themes/jungleVibrantColorscheme.conf".source = ../../files/config/kitty/themes/jungleVibrantColorscheme.conf;
    ".config/kitty/themes/jungleColorscheme.conf".source = ../../files/config/kitty/themes/jungleColorscheme.conf;
  };
  # Btop
  home.file = {
    ".config/btop/btop.conf".source = ../../files/config/btop/btop.conf;
    ".config/btop/themes/rumda.theme".source = ../../files/config/btop/themes/rumda.theme;
  };
  # Hyprlock
  home.file = {
    ".config/hyprlock/hyprlock.conf".source = ../../files/config/hyprlock/hyprlock.conf;
    ".config/hyprlock/hyprlock.png".source = ../../files/config/hyprlock/hyprlock.png;
    ".config/hyprlock/songdetail.sh".source = ../../files/config/hyprlock/songdetail.sh;
    ".config/hyprlock/vivek.jpg".source = ../../files/config/hyprlock/vivek.jpg;
    ".config/hyprlock/Fonts/JetBrains/JetBrains Mono Nerd.ttf".source =
      ../../files/config/hyprlock/Fonts/JetBrains/JetBrains_Mono_Nerd.ttf;
    ".config/hyprlock/Fonts/SF Pro Display/SF Pro Display Bold.otf".source =
      ../../files/config/hyprlock/Fonts/SF_Pro_Display/SF_Pro_Display_Bold.otf;
    ".config/hyprlock/Fonts/SF Pro Display/SF Pro Display Regular.otf".source =
      ../../files/config/hyprlock/Fonts/SF_Pro_Display/SF_Pro_Display_Regular.otf;
  };
  # Zathura
  home.file.".config/zathura/zathurarc" = {
    source = ../../files/config/zathura/zathurarc;
  };
  # Wallpapers
  home.file = {
    "Pictures/Wallpapers/filianElevator.png".source = ../../files/pictures/filianElevator.png;
    "Pictures/Wallpapers/dangerousFilian.png".source = ../../files/pictures/dangerousFilian.png;
    "Pictures/Wallpapers/dangeroooous_jungle_wp.png".source = ../../files/pictures/dangeroooous_jungle_wp.png;
    "Pictures/Wallpapers/marnieGruvbox.png".source = ../../files/pictures/marnieGruvbox.png;
    "Pictures/Wallpapers/demeLook.jpg".source = ../../files/pictures/demeLook.jpg;
    "Pictures/Wallpapers/helltakerStare.jpg".source = ../../files/pictures/helltakerStare.jpg;
    "Pictures/Wallpapers/lainGruvbox.jpg".source = ../../files/pictures/lainGruvbox.jpg;
    "Pictures/Wallpapers/nixosAnime.png".source = ../../files/pictures/nixosAnime.png;
    "Pictures/Wallpapers/fuwamoco.jpg".source = ../../files/pictures/fuwamoco.jpg;
    "Pictures/Wallpapers/guix_wp_01.svg".source = ../../files/pictures/guix_wp_01.svg;
    "Pictures/Wallpapers/guix_wp_02.svg".source = ../../files/pictures/guix_wp_02.svg;
    "Pictures/Wallpapers/guix_wp_01.png".source = ../../files/pictures/guix_wp_01.png;
    "Pictures/Wallpapers/guix_wp_02.png".source = ../../files/pictures/guix_wp_02.png;
  };
  # Rofi
  home.file = {
    ".config/rofi/colors.rasi".source = ../../files/config/rofi/colors.rasi;
    ".config/rofi/config.rasi".source = ../../files/config/rofi/config.rasi;
    ".config/rofi/fonts.rasi".source = ../../files/config/rofi/fonts.rasi;
  };
  # Yazi
  home.file = {
    ".config/yazi/Gruvbox-Dark.tmTheme".source = ../../files/config/yazi/Gruvbox-Dark.tmTheme;
    ".config/yazi/theme.toml".source = ../../files/config/yazi/theme.toml;
  };
  # Nix-Search-TV
  home.file.".config/nix-search-tv/config.toml".source = ../../files/config/television/config.toml;
  home.file.".config/nix-search-tv/config.json".source = ../../files/config/television/config.json;
  home.file.".config/television/cable/nix.toml".source = ../../files/config/television/nix.toml;
  home.file.".scripts/mango-exit.sh" = {
    text = ''
      #!/usr/bin/env sh

      choice=$(printf "no\nyes" | wofi --dmenu \
        --prompt "Exit MangoWC?" \
        --width 300 \
        --height 150)

      if [ "$choice" = "yes" ]; then
          kill $(pidof mango)
      else
          return
      fi
    '';
    executable = true;
  };
  home.file.".scripts/naitreHUDBackup.sh" = {
    source = ../../files/scripts/naitreHUDBackup.sh;
    executable = true;
  };
  home.file.".scripts/polybar.sh" = {
    text = ''
      if type "xrandr"; then
        for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
          MONITOR=$m polybar --reload main &
        done
      else
        polybar --reload main &
      fi
    '';
    executable = true;
  };
  home.file.".scripts/viewScreenshot.sh" = {
    source = ../../files/scripts/viewScreenshot.sh;
    executable = true;
  };
  home.file.".config/make/config" = {
    source = ../../files/config/mako/config;
    executable = true;
  };
  home.file.".config/dunst/dunstrc".source = ../../files/config/dunst/dunstrc;
  home.file.".scripts/screenkey.nix".text = ''
    { pkgs ? import <nixpkgs> {} }:
    pkgs.mkShell {
      buildInputs = with pkgs; [
        screenkey
      ];
      shellHook = '''
        clear;echo "Starting Screenkey"
        screenkey --font "DejaVu Sans Mono" -t 0.65 --vis-shift
        clear;echo "Quitting Screenkey"
        exit
      ''';
    }
  '';
  home.file.".scripts/ncdu.nix".text = ''
    { pkgs ? import <nixpkgs> {} }:
    pkgs.mkShell {
      buildInputs = [
        pkgs.ncdu
      ];
      shellHook = '''
        ncdu
        exit
      ''';
    }
  '';
  home.file.".config/rofi/old/config.rasi".text = ''
    configuration {
      font: "DejaVu Sans Mono 12";
      show-icons: true;
      location: 0;
      fullscreen: false;
    }

    @theme "squared-loji"
  '';
  home.file.".config/rofi/old/squared-nord.rasi".source = ../../files/config/rofi/old/squared-nord.rasi;
  home.file.".config/rofi/old/squared-loji.rasi".source = ../../files/config/rofi/old/squared-loji.rasi;
}
