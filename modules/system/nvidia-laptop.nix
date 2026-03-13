{ config, pkgs, lib, inputs, ... }:
{
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];
  environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json".text =
    builtins.toJSON {
      rules = [
        {
          pattern = {
            feature = "procname";
            matches = [ "niri" ];
          };
          profile = "Limit free buffer pool on Wayland compositors";
        }
      ];
      profiles = [
        {
          name = "Limit free buffer pool on Wayland compositors";
          settings = [
            {
              key = "GLVidHeapReuseRatio";
              value = 0;
            }
            {
              key = "GLUseEGL";
              value = 0;
            }
          ];
        }
      ];
    };
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
    nixpkgs.config.nvidia.acceptLicense = true;
    hardware.nvidia = {
      open = false;
      modesetting.enable = true;
      nvidiaPersistenced = true;
      powerManagement.enable = true;
      # For Kepler K2100M ThinkPad W540 GPU, use 'legacy_470' Driver.
      package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
      prime = {
        sync.enable = true;
        # Check BUS-IDs via 'lspci | grep VGA'.
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
}
