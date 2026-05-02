{ config, pkgs, inputs, ... }:
{
  services = {
    desktopManager = {
      gnome.enable = true;
      plasma6.enable = true;
    };
    displayManager = {
      defaultSession = "none+xmonad";
      gdm.enable = false;
      gdm.wayland = false;
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
  };
  # Xorg
  services.xserver.xrandrHeads = [
    {
      output = "DP-0";
      monitorConfig = ''
        Option "Mode" "1920x1080"
        Option "Rate" "144"
        Option "Primary" "true"
        Option "Position" "0 0"
      '';
    }
    {
      output = "HDMI-0";
      monitorConfig = ''
        Option "Mode" "1920x1080"
        Option "Rate" "60"
        Option "Position" "1920 0"
      '';
    }
  ];
  services.xserver = {
    videoDrivers = [ "nvidia" ];
    enable = true;
    xkb = {
      layout = "us";
      variant = "colemak";
    };
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      # extraPackages = hpkgs: [
      #   hpkgs.X11
      #   hpkgs.X11-xshape
      #   hpkgs.xmonad-contrib
      #   hpkgs.xmonad-extras
      # ];
    };
    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks
        luadbi-mysql
        awesome-wm-widgets
      ];
    };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3blocks
        autotiling
        polybarFull
        picom
        betterlockscreen
        dunst
        libnotify
        eww
      ];
      package = pkgs.i3-rounded;
    };
  };
}
