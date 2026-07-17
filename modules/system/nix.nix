{ config, pkgs, inputs, lib, ... }:
{
  nix = {
    gc = {
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 30d";
    };
    settings = {
      # extra-
      substituters = [
        "https://cache.nixos.org"
        "https://nix-gaming.cachix.org"
        "https://nix-community.cachix.org"
        "https://ai.cachix.org"
        "https://cache.xinux.uz"
        "https://cache.nixos-cuda.org"
      ];
      trusted-substituters = [
        "https://cache.nixos.org"
        "https://nix-gaming.cachix.org"
        "https://nix-community.cachix.org"
        "https://ai.cachix.org"
        "https://cache.xinux.uz"
        "https://cache.nixos-cuda.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
        "cache.xinux.uz:BXCrtqejFjWzWEB9YuGB7X2MV4ttBur1N8BkwQRdH+0="
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      ];
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      max-jobs = "auto";
      cores = 0;
      connect-timeout = 30;
      trusted-users = [ "root" "puppy" ];
    };
    extraOptions = ''
      warn-dirty = false
      allow-dirty = true
      show-trace = true
      substitute = true
      fallback = true
      auto-optimise-store = true
      min-free = 5368709120
      max-free = 21474836480
    '';
  };
  nixpkgs.config = {
    # cudaSupport = true;
    allowUnfree = true;
    permittedInsecurePackages = [
      "librewolf-bin-148.0-1"
      "librewolf-bin-unwrapped-148.0-1"
      "openclaw-2026.5.7"
    ];
  };
}
