{ config, lib, pkgs, inputs, ... }:
{
  systemd.services.multiwan-failover = {
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Restart = "always";
      RestartSec = 2;
      Type = "simple";
    };

    script = ''
      #!/usr/bin/env bash

      ETH_CONN="Wired connection 1"
      ETH_IF="enp0s31f6"
      WIFI_IF="wlp4s0u2"

      ETH_GOOD_METRIC=100
      ETH_BAD_METRIC=2000
      WIFI_METRIC=600

      while true; do
        # ---- REAL connectivity checks ----
        if ping -I "$ETH_IF" -c 1 -W 1 1.1.1.1 >/dev/null 2>/dev/null; then
          ETH_OK=1
        else
          ETH_OK=0
        fi

        if ping -I "$WIFI_IF" -c 1 -W 1 8.8.8.8 >/dev/null; then
          WIFI_OK=1
        else
          WIFI_OK=0
        fi

        # ---- decision logic ----
        if [ "$ETH_OK" -eq 1 ]; then
          ${pkgs.networkmanager}/bin/nmcli connection modify "$ETH_CONN" \
            ipv4.route-metric $ETH_GOOD_METRIC ipv6.route-metric $ETH_GOOD_METRIC
        else
          ${pkgs.networkmanager}/bin/nmcli connection modify "$ETH_CONN" \
            ipv4.route-metric $ETH_BAD_METRIC ipv6.route-metric $ETH_BAD_METRIC
        fi

        sleep 60
      done
    '';
  };
  networking = {
    networkmanager = {
      enable = true;
      insertNameservers = [
        "1.1.1.1"
        "8.8.8.8"
      ];
      ### Old Connectivity Status Checker
      # settings = {
      #   connectivity = {
      #     enabled = true;
      #     uri = "https://nmcheck.gnome.org/check_network_status.txt";
      #     interval = 60;
      #   };
      # };
    };
    hostName = "snowflake";
    ### Old Nameservers Snippet, apparently not Required and can Conflict,
    ### when Nameservers are also set via NetworkManager.
    # nameservers = [
    #   "1.1.1.1"
    #   "8.8.8.8"
    # ];
    firewall = {
      checkReversePath = lib.mkForce false; # Required to get VPNs like ProtonVPN to Work.
      ### Old TCP Port Rules
      # allowedTCPPorts = [
      #   53317
      # ];
      # allowedUDPPorts = [
      #   53317
      # ];
    };
  };
}
