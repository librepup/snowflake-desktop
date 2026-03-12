{ config, pkgs, inputs, ... }:
{
  networking = {
    networkmanager = {
      enable = true;
      insertNameservers = [
        "1.1.1.1"
        "8.8.8.8"
      ];
    };
    hostName = "snowflake";
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    firewall.checkReversePath = false;
  };
}
