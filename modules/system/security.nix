{
  config,
  pkgs,
  inputs,
  ...
}:
{
  services = {
    dbus = {
      packages = [
        pkgs.gcr
      ];
    };
  };
  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = true;
      extraRules = [
        {
          commands = [
            {
              command = "${pkgs.systemd}/bin/reboot";
              options = [ "NOPASSWD" ];
            }
            {
              command = "${pkgs.systemd}/bin/poweroff";
              options = [ "NOPASSWD" ];
            }
          ];
          groups = [ "wheel" ];
        }
      ];
    };
    doas = {
      enable = true;
      wheelNeedsPassword = true;
      extraRules = [
        {
          groups = [ "wheel" ];
          noPass = false;
          keepEnv = true;
          persist = true;
        }
        {
          users = [ "puppy" ];
          noPass = true;
          keepEnv = true;
          cmd = "/run/current-system/sw/bin/nixos-rebuild";
        }
        {
          users = [ "puppy" ];
          noPass = true;
          keepEnv = true;
          cmd = "/run/current-system/sw/bin/nix-collect-garbage";
        }
      ];
    };
  };
}
