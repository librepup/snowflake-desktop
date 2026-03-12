{ config, pkgs, inputs, ... }:
{
  users.users.glenda = {
    isNormalUser = true;
    description = "Glenda Plan9 User";
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      "plugdev"
      "guixbuild"
    ];
    shell = pkgs.plan9port + "/plan9/bin/rc";
    packages = with pkgs;
    let
      plan9-term = pkgs.writeShellScriptBin "term" ''
        exec ${pkgs.plan9port}/bin/9 9term "$@"
      '';
      plan9-acme = pkgs.writeShellScriptBin "acme" ''
        exec ${pkgs.plan9port}/bin/9 acme "$@"
      '';
      plan9-rc-shell = pkgs.writeShellScriptBin "rc" ''
        exec ${pkgs.plan9port}/bin/9 rc "$@"
      '';
      plan9-rio = pkgs.writeShellScriptBin "rio" ''
        exec ${pkgs.plan9port}/bin/9 rio "$@"
      '';
      plan9-ls-full = pkgs.writeShellScriptBin "ls" ''
        exec ${pkgs.plan9port}/bin/9 ls "$@"
      '';
      plan9-ls-short = pkgs.writeShellScriptBin "l" ''
        exec ${pkgs.plan9port}/bin/9 ls "$@"
      '';
    in
    [
      plan9port
      plan9-term
      plan9-acme
      plan9-rc-shell
      plan9-rio
      plan9-ls-full
      plan9-ls-short
    ];
  };
}
