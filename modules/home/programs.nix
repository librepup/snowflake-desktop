{ config, pkgs, lib, inputs, unstable, ... }:
{
  programs.mpv = {
    enable = true;
    config = {
      volume = 50;
      force-window = false;
      "autofit-larger" = "75%x75%";
      "image-display-duration" = "inf";
      "hr-seek" = true;
      "loop-playlist" = "inf";
      "loop-file" = "inf";
    };
    bindings = {
      n = "playlist-next";
      p = "playlist-prev";
      "Shift+Enter" = "playlist-next";
      PGDWN = "playlist-next";
      PGUP = "playlist-prev";
      "Shift+p" = "show-text $\{playlist\}";
      UP = "add volume 5";
      DOWN = "add volume -5";
      WHEEL_UP = "add volume 2";
      WHEEL_DOWN = "add volume -2";
      WHEEL_LEFT = "add volume -2";
      WHEEL_RIGHT = "add volume 2";
      d = "set volume 50";
      RIGHT = "seek 5";
      LEFT = "seek -5";
      "Shift+RIGHT" = "seek 1";
      "Shift+LEFT" = "seek -1";
      "Ctrl+RIGHT" = "add speed 0.1";
      "Ctrl+LEFT" = "add speed -0.1";
      "]" = "add audio-delay 0.100";
      "[" = "add audio-delay -0.100";
      r = "no-osd cycle video-rotate 90";
      R = "no-osd cycle video-rotate -90";
      q = "quit";
      "+" = "add video-zoom 0.1";
      "_" = "add video-zoom -0.1";
      "=" = "set video-zoom 0";
      "," = "frame-back-step";
      "." = "frame-step";
      "META+LEFT" = "add video-pan-x 0.1";
      "META+RIGHT" = "add video-pan-x -0.1";
      "META+UP" = "add video-pan-y 0.1";
      "META+DOWN" = "add video-pan-y -0.1";
    };
  };
  programs.alacritty = {
    enable = true;
    settings = {
      general = {
        live_config_reload = true;
      };
      colors = {
        #primary = {
        #  foreground = "#c5c8c6";
        #  background = "#1d1f21";
        #};
        #cursor = {
        #  text = "#1d1f21";
        #  cursor = "#ffffff";
        #};
        #normal = {
        #  black = "#1d1f21";
        #  red = "#cc6666";
        #  green = "#b5bd68";
        #  yellow = "#e6c547";
        #  blue = "#81a2be";
        #  magenta = "#b294bb";
        #  cyan = "#70c0ba";
        #  white = "#373b41";
        #};
        #bright = {
        #  black = "#665c54";
        #  red = "#ff3334";
        #  green = "#9ec400";
        #  yellow = "#f0c674";
        #  blue = "#81a2be";
        #  magenta = "#b77ee0";
        #  cyan = "#54ced6";
        #  white = "#282a2e";
        #};
      };
      font = lib.mkForce {
        offset = {
          x = 0;
          y = 0;
        };
        normal = {
          family = "DejaVu Sans Mono";
          style = "Regular";
        };
        size = 14;
      };
      cursor.style = {
        shape = "Beam";
        blinking = "Off";
      };
      window.padding = {
        x = 5;
        y = 5;
      };
    };
  };
  programs.kitty = {
    enable = true;
    extraConfig = ''
      ###########################
      ### Kitty Configuration ###
      ###########################
      ### General Settings
      hide_window_decorations no
      enable_audio_bell no
      confirm_os_window_close 0

      ### Colors
      selection_foreground    #ebdbb2
      selection_background    #d65d0e
      background              #282828
      foreground              #ebdbb2
      color0                  #3c3836
      color1                  #cc241d
      color2                  #98971a
      color3                  #d79921
      color4                  #458588
      color5                  #b16286
      color6                  #689d6a
      color7                  #a89984
      color8                  #928374
      color9                  #fb4934
      color10                 #b8bb26
      color11                 #fabd2f
      color12                 #83a598
      color13                 #d3869b
      color14                 #8ec07c
      color15                 #fbf1c7
      cursor                  #bdae93
      cursor_text_color       #665c54
      url_color               #458588

      ### Cursor
      cursor_shape beam
      cursor_blink_interval 0

      ### Font
      font_family DejaVu Sans Mono
      font_size 16.0

      ### Tabs
      tab_bar_style separator
      tab_separator ""
      tab_bar_min_tabs 2
      tab_title_template "{fmt.fg._282828}{fmt.bg._282828}{fmt.fg._ebdbb2}{fmt.bg._282828} ({index}) {title} {fmt.fg._282828}{fmt.bg._282828} "
      active_tab_title_template "{fmt.fg._ebdbb2}{fmt.bg._282828}{fmt.fg._d65d0e}{fmt.bg._ebdbb2} ({index}) {title} {fmt.fg._ebdbb2}{fmt.bg._282828} "
      active_tab_font_style bold
      map ctrl+1 goto_tab 1
      map ctrl+2 goto_tab 2
      map ctrl+3 goto_tab 3
      map ctrl+4 goto_tab 4
      map ctrl+5 goto_tab 5
      map ctrl+6 goto_tab 6
      map ctrl+7 goto_tab 7
      map ctrl+8 goto_tab 8
      map ctrl+9 goto_tab 9
      map ctrl+t new_tab
      map ctrl+w close_tab
      map ctrl+shift+page_up move_tab_backward
      map ctrl+shift+page_down move_tab_forward
      active_tab_foreground   #d65d0e
      active_tab_background   #282828
      inactive_tab_foreground #ebdbb2
      inactive_tab_background #282828
      tab_bar_background      #282828

      ### Padding
      window_padding_width 3

      ### Keybinds
      map ctrl+shift+l send_text normal,application l\r

      ### User Config
      include ~/.config/kitty/main.conf
    '';
  };
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
}
