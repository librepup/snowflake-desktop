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
            kp2 = "z";
            kp3 = "x";
            kp0 = "space";
            kpplus = "c";
            kpequal = "delete";
            kpdot = "layer(alt)";
          };
          alt = {
            kp1 = "w";
            kp0 = "w";
            kpenter = "layer(shift)";
            kpplus = "layer(control)";
          };
          control = {
            kp1 = "y";
            kp0 = "y";
            kp7 = "macro(C-x [)";
            kp9 = "macro(C-x ])";
            kp3 = "macro(C-x ])";
          };
          extralayer = {
            kpenter = "enter";
            v = "A-w";
            c = "C-y";
            "[" = "macro(C-x [)";
            "]" = "macro(C-x ])";
            up = "macro(C-x [)";
            down = "macro(C-x ])";
            x = "A-x";
          };
          "alt+shift" = {
            kpenter = "enter";
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
    kp2 = z
    kp3 = x
    kp0 = space
    kpplus = c
    kpequal = delete
    kpdot = layer(alt)

    [alt]
    kp1 = w
    kp0 = w
    kpenter = layer(shift)
    kpplus = layer(control)

    [control]
    kp1 = y
    kp0 = y
    kp7 = macro(C-x [)
    kp9 = macro(C-x ])
    kp3 = macro(C-x ])

    [extralayer]
    kpenter = enter
    v = A-w
    c = C-y
    [ = macro(C-x [)
    ] = macro(C-x ])
    up = macro(C-x [)
    down = macro(C-x ])
    x = A-x

    [alt+shift]
    kpenter = enter
  '';
}
