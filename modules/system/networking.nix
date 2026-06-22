{ config, lib, pkgs, inputs, ... }:
{
  networking = {
    networkmanager = {
      enable = true;
      settings = {
        connectivity = {
          enabled = true;
          uri = "https://nmcheck.gnome.org/check_network_status.txt";
          interval = 30;
        };
        connection-ethernet = {
          "ipv4.route-metric" = 100;
          "ipv6.route-metric" = 100;
        };
        connection-wifi = {
          "ipv4.route-metric" = 600;
          "ipv6.route-metric" = 600;
        };
      };
      insertNameservers = [
        "1.1.1.1"
        "8.8.8.8"
      ];
      dispatcherScripts = [
        {
          source = pkgs.writeShellScript "connectivityUpdateHook" ''
            if [ "$2" = "up" ] || [ "$2" = "down" ] || [ "$2" = "connectivity-change" ]; then
              case "$1" in
                enp0s31f6|enp*)
                  sudo -u "puppy" DISPLAY=":0" DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u puppy)/bus" ${pkgs.libnotify}/bin/notify-send "$1" "Connected to $1 after $2" -i /run/current-system/sw/share/icons/breeze-dark/status/24/network-wired.svg
                  ;;
                wlp4s0u2|wlp*)
                  sudo -u "puppy" DISPLAY=":0" DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u puppy)/bus" ${pkgs.libnotify}/bin/notify-send "$1" "Connected to $1 after $2" -i /run/current-system/sw/share/icons/breeze-dark/status/24/network-wireless-on.svg
                  ;;
                *)
                  sudo -u "puppy" DISPLAY=":0" DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u puppy)/bus" ${pkgs.libnotify}/bin/notify-send "Unknown" "Network Changed to Unknown Mode" -i /etc/nixos/files/pictures/icons/error.png
                  ;;
              esac
            fi
          '';
          type = "basic";
        }
      ];
    };
    hostName = "snowflake";
    firewall = {
      checkReversePath = lib.mkForce false; # Required to get VPNs like ProtonVPN to Work.
    };
  };
}
