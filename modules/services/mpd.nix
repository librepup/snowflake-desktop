{ config, pkgs, lib, inputs, ... }:
{
  services.mpd = {
    enable = true;
    musicDirectory = "/mnt/Files/Music";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "My PipeWire Output"
      }
    '';
    user = "userRunningPipeWire";
  };
  systemd.services.mpd.environment = {
    XDG_RUNTIME_DIR = "/run/user/${toString config.users.users.userRunningPipeWire.uid}";
  };
  systemd.services.mpd.wantedBy = lib.mkForce [ ];
}
