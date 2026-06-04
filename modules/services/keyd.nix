{ config, pkgs, lib, inputs, ... }:
{
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [
          "*"
        ];
        settings = {
          main = {
            kpasterisk = "layer(extralayer)";
            rightshift = "layer(meta)";
            capslock = "layer(control)";
            rightalt = "altgr";
            f21 = "f21";
            f22 = "f22";
            kp4 = "left";
            kp5 = "down";
            kp6 = "right";
            kp8 = "up";
            kp2 = "backspace";
            kp3 = "layer(meta)";
            kp1 = "delete";
            kp0 = "space";
            kpplus = "c";
            kpequal = "delete";
            kpdot = "layer(alt)";
            kpslash = "slash";
          };
          control = {
            kp7 = "macro(C-x [)";
            kp9 = "macro(C-x ])";
            kp3 = "macro(C-x ])";
          };
          extralayer = {
            "1" = "f1";
            "2" = "f2";
            "3" = "f3";
            "4" = "f4";
            "5" = "f5";
            "6" = "f6";
            "7" = "f7";
            "8" = "f8";
            "9" = "f9";
            "0" = "f10";
            minus = "f11";
            equal = "f12";
            "[" = "macro(C-x [)";
            "]" = "macro(C-x ])";
            up = "macro(C-x [)";
            down = "macro(C-x ])";
            x = "A-x";
          };
        };
      };
    };
  };
  environment.etc."keyd/config.conf".text = ''
    [ids]
    *

    [main]
    kpasterisk = layer(extralayer)
    rightshift = layer(meta)
    capslock = layer(control)
    rightalt = altgr
    f21 = f21
    f22 = f22
    kp4 = left
    kp5 = down
    kp6 = right
    kp8 = up
    kp2 = backspace
    kp3 = layer(meta)
    kp1 = delete
    kp0 = space
    kpplus = c
    kpequal = delete
    kpdot = layer(alt)
    kpslash = slash

    [control]
    kp7 = macro(C-x [)
    kp9 = macro(C-x ])
    kp3 = macro(C-x ])

    [extralayer]
    1 = f1
    2 = f2
    3 = f3
    4 = f4
    5 = f5
    6 = f6
    7 = f7
    8 = f8
    9 = f9
    0 = f10
    minus = f11
    equal = f12
    [ = macro(C-x [)
    ] = macro(C-x ])
    up = macro(C-x [)
    down = macro(C-x ])
    x = A-x
  '';
}
