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
