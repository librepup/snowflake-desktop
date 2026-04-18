{ config, pkgs, lib, inputs, ... }:
{
  nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
  hardware.enableRedistributableFirmware = true;
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
}
