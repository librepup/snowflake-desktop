{ config, pkgs, lib, inputs, ... }:
{
  programs = {
    less = {
      enable = true;
    };
    git = {
      enable = true;
      config = {
        safe = {
          directory = "/etc/nixos";
        };
      };
    };
    ssh = {
      askPassword = lib.mkForce "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    fzf = {
      fuzzyCompletion = true;
    };
    nix-ld = {
      enable = true;
    };
  };
}
