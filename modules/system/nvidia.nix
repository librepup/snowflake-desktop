{ config, pkgs, inputs, ... }:
{
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm"; # In case of issues, try removing this variable, as it's not required on newer 580 Drivers.
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
    "mitigations=off"
    "nmi_watchdog=0"
    "nvidia_modeset.vblank_sem_control=0"
  ];
  boot.initrd.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      modesetting.enable = true;
      powerManagement = {
        enable = true;
        finegrained = false;
        kernelSuspendNotifier = true;
      };
      open = false;
      nvidiaSettings = true;
    };
    nvidia-container-toolkit = {
      enable = true;
      mount-nvidia-executables = true;
    };
  };
}
