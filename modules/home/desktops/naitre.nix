{ config, pkgs, lib, inputs, unstable, ... }:
{
  wayland.windowManager.naitre = {
    enable = true;
    modularize = {
      enable = true;
      additional = ''
        #------------#
        # Additional #
        #------------#
        # Autostart
        exec-once=wl-paste --watch cliphist store
        exec-once=dex --autostart environment naitre
        exec-once=gammastep -l 52.520008:13.404954 -t 4000:4000
        exec-once=dunst
        exec-once=dms run
        exec-once=vicinae server
        exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
        exec-once=sway-audio-idle-inhibit
        exec=xwayland-satellite :0
      '';
    };
    scripts = {
      exit = {
        enable = true;
        launcher = "vicinae";
        keybind = "Alt+Shift,x";
      };
      pavucontrol = {
        enable = true;
        keybind = "SUPER,a";
      };
      vicinaeDmenuRun = {
        enable = true;
        keybind = "SUPER,t";
      };
    };
  };
}
