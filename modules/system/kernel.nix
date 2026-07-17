{ config, pkgs, lib, inputs, ... }:
{
  boot.kernel.sysctl = {
    "net.core.netdev_max_backlog" = 16384;
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "fq";
  };
  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.pinned
  ];
  hardware.enableRedistributableFirmware = true;
  boot.kernelPackages = inputs.nix-cachyos-kernel.legacyPackages.x86_64-linux.linuxPackages-cachyos-lts; # pkgs.cachyosKernels.linuxPackages-cachyos-latest;
  # inputs.nix-cachyos-kernel.legacyPackages.x86_64-linux.linuxPackages-cachyos-latest;
  boot.extraModprobeConfig = ''
    install algif_aead /bin/false
  '';
  boot.blacklistedKernelModules = [
    "nouveau"
  ];
}
