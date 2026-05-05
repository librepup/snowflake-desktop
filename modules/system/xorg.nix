{ config, pkgs, inputs, ... }:
let
  hevelPkg = inputs.neu-nix.packages.x86_64-linux.hevel;
  neuswcPkg = inputs.neu-nix.packages.x86_64-linux.neuswc;
  tohuPkg = inputs.neu-nix.packages.x86_64-linux.tohu;
  hevelSession = (pkgs.writeTextDir "share/wayland-sessions/hevel.desktop" ''
    [Desktop Entry]
    Name=hevel
    Comment=Custom Hevel WM Session
    Exec=${neuswcPkg}/bin/swc-launch ${hevelPkg}/bin/hevel
    Type=Application
  '').overrideAttrs (oldAttrs: {
    passthru.providedSessions = [ "hevel" ];
  });
  tohuSession = (pkgs.writeTextDir "share/wayland-sessions/tohu.desktop" ''
    [Desktop Entry]
    Name=tohu
    Comment=Custom Tohu WM Session
    Exec=${neuswcPkg}/bin/swc-launch ${tohuPkg}/bin/tohu
    Type=Application
  '').overrideAttrs (oldAttrs: {
    passthru.providedSessions = [ "tohu" ];
  });
in
{
  environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json".text =
    builtins.toJSON {
      rules = [
        {
          pattern = {
            feature = "procname";
            matches = [ "niri" ];
          };
          profile = "Limit free buffer pool on Wayland compositors";
        }
      ];
      profiles = [
        {
          name = "Limit free buffer pool on Wayland compositors";
          settings = [
            {
              key = "GLVidHeapReuseRatio";
              value = 0;
            }
            {
              key = "GLUseEGL";
              value = 0;
            }
          ];
        }
      ];
    };
  services = {
    desktopManager = {
      gnome.enable = true;
      plasma6.enable = true;
    };
    displayManager = {
      #defaultSession = "none+xmonad";
      defaultSession = "niri";
      gdm.enable = false;
      gdm.wayland = false;
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      sessionPackages = [
        hevelSession
        tohuSession
      ];
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
    windowManager.windowmaker = {
      enable = true;
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
