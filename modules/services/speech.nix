{ config, pkgs, lib, inputs, ... }:
{
  services = {
    speechd = {
      enable = true;
    };
  };
  systemd.services.speech-dispatcherd.wantedBy = lib.mkForce [ ];
}
