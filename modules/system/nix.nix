{ config, pkgs, inputs, ... }:
{
  nix = {
    gc = {
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 30d";
    };
    settings = {
      substituters = [
        "https://attic.xuyh0120.win/lantian"
        "https://nix-gaming.cachix.org"
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=""lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      max-jobs = "auto";
      cores = 0;
      connect-timeout = 5;
      trusted-users = [ "root" "puppy" ];
    };
    # Options keep-outputs and keep-derivations are used for persistent, non-garbage-collected nix-shell packages. Remove if they cause trouble.
    extraOptions = ''
      warn-dirty = false
      allow-dirty = true
      auto-optimise-store = true
      download-attempts = 10
      keep-outputs = true
      keep-derivations = true
    '';
  };
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "librewolf-bin-148.0-1"
      "librewolf-bin-unwrapped-148.0-1"
    ];
  };
}
