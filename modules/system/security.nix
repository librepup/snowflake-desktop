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
    gnome = {
      gnome-keyring.enable = false;
    };
  };
  security = {
    pam = {
      services.login.enableGnomeKeyring = false;
      services.sddm.enableGnomeKeyring = false;
    };
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
      ];
    };
  };
}
