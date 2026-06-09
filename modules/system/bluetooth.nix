{ config, pkgs, inputs, ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      Policy = {
        AutoEnable = true;
      };
    };
  };
  # If 'journalctl -eu bluetooth' shows it's blocked, run
  # 'doas rfkill unblock bluetooth' to free it.
  services.blueman = {
    enable = true;
  };
}
