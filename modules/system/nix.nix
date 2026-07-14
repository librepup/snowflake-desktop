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
        # "https://cuda.cachix.org"
        "https://nix-gaming.cachix.org"
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
        # "https://cuda-maintainers.cachix.org"
        "https://cache.xinux.uz"
        "https://attic.xuyh0120.win/lantian"
      ];
      # Can be commented out.
      trusted-substituters = [
        "https://cache.nixos.org"
        "https://nix-gaming.cachix.org"
        # "https://cuda.cachix.org"
        "https://nix-community.cachix.org"
        # "https://cuda-maintainers.cachix.org"
        "https://ai.cachix.org"
        "https://cache.xinux.uz"
        "https://attic.xuyh0120.win/lantian"
      ];
      # -extra
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        # "cuda.cachix.org-1:oF5HhrlMH2gjBQat0LPulr0+fwjh1eQKglWMm8F7a2Q="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        # "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
        "cache.xinux.uz:BXCrtqejFjWzWEB9YuGB7X2MV4ttBur1N8BkwQRdH+0="
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=""lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      ];
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      max-jobs = "auto";
      cores = 0;
      connect-timeout = 10;
      trusted-users = [ "root" "puppy" ];
    };
    # Options keep-outputs and keep-derivations are used for persistent, non-garbage-collected nix-shell packages. Remove if they cause trouble.
    extraOptions = ''
      warn-dirty = false
      allow-dirty = true
      show-trace = true
      substitute = true
      auto-optimise-store = true
      keep-outputs = true
      keep-derivations = true
    '';
  };
  nixpkgs.config = {
    cudaSupport = true;
    allowUnfree = true;
    permittedInsecurePackages = [
      "librewolf-bin-148.0-1"
      "librewolf-bin-unwrapped-148.0-1"
      "openclaw-2026.5.7"
    ];
  };
}
