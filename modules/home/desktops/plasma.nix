{ config, pkgs, lib, inputs, unstable, ... }:
{
  qt = {
    enable = true;
    platformTheme.name = "kde";
    style.name = "kvantum";
  };
  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=Windows7Aero
  '';
  programs.plasma = {
    enable = true;
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
    };
    fonts = {
      fixedWidth.family = "Source Code Pro for Powerline";
    };
    input = {
      keyboard = {
        numlockOnStartup = "on";
      };
    };
    hotkeys = {
      commands = {
        launch-edge = {
          name = "Launch Microsoft Edge";
          key = "Alt+S";
          command = "microsoft-edge";
        };
        launch-kitty = {
          name = "Launch Kitty";
          key = "Alt+Shift+Return";
          command = "kitty";
        };
        launch-goofcord = {
          name = "Launch GoofCord (No GPU)";
          key = "Super+Shift+G";
          command = "goofcord --enable-features=UseOzonePlatform --ozone-platform=x11 --disable-gpu";
        };
      };
    };
    kwin = {
      effects = {
        blur = {
          enable = true;
          noiseStrength = 0;
          strength = 6;
        };
        slideBack.enable = true;
        translucency.enable = true;
        wobblyWindows.enable = false;
      };
    };
    virtualDesktops = {
      number = 10;
      rows = 1;
    };
    krunner = {
      position = "center";
    };
    spectacle = {
      shortcuts = {
        captureRectangularRegion = "Alt+a";
      };
    };
  };
}
