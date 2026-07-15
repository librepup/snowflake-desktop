{
  description = "NixOS Systems Flake for System (Snowflake)";
  inputs = {
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-gaming.url = "github:fufexan/nix-gaming";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flatpaks.url = "github:in-a-dil-emma/declarative-flatpak/latest";
    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
    };
    noctalia = {
      url = "github:librepup/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    # vicinae.url = "github:vicinaehq/vicinae";
    # vicinae-extensions = {
    #   url = "github:vicinaehq/extensions";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-search-tv.url = "github:3timeslazy/nix-search-tv";
    # mango = {
    #   url = "github:DreamMaoMao/mango"; # Add "?ref=vertical-stack" to the url end for specific branch.
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # naitre = {
    #   url = "github:librepup/NaitreHUD";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nixmacs = {
      url = "github:librepup/NixMacs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    # aerothemeplasma-nix = {
    #   url = "github:nyakase/aerothemeplasma-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # astal = {
    #   url = "github:aylur/astal";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    jonabron.url = "github:librepup/jonabron";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-init = {
      url = "github:nix-community/nix-init";
    };
    millennium = {
      url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
    };
    helium = {
      url = "github:tomsch/helium-nix";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-snapd = {
      url = "github:nix-community/nix-snapd";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neu-nix = {
      url = "github:ricardomaps/neu-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixified-ai = {
      url = "github:nixified-ai/flake";
    };
    stability-matrix-nix = {
      url = "github:SmarakNayak/stability-matrix-nix";
    };
    hermes-agent = {
      url = "github:NousResearch/hermes-agent";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      stylix,
      nix-index-database,
      nixmacs,
      nixvim,
      noctalia,
      nix-alien,
      nix-search-tv,
      # vicinae,
      # mango,
      # naitre,
      nixpkgs-unstable,
      dms,
      dgop,
      spicetify-nix,
      nix-cachyos-kernel,
      nix-gaming,
      jonabron,
      zen-browser,
      nix-init,
      millennium,
      flatpaks,
      nur,
      nix-snapd,
      neu-nix,
      nixified-ai,
      stability-matrix-nix,
      hermes-agent,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          cudaSupport = true;
          permittedInsecurePackages = [
            "librewolf-bin-148.0-1"
            "librewolf-bin-unwrapped-148.0-1"
            "openclaw-2026.5.7"
          ];
        };
      };
    in
    {
      nixosConfigurations.snowflake = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./modules/default.nix
          stylix.nixosModules.stylix
          nix-index-database.nixosModules.nix-index
          home-manager.nixosModules.home-manager
          # mango.nixosModules.mango
          # naitre.nixosModules.naitre
          inputs.spicetify-nix.nixosModules.default
          nur.modules.nixos.default
          nix-snapd.nixosModules.default
          inputs.nixified-ai.nixosModules.comfyui
          hermes-agent.nixosModules.default
          # Nixpkgs Config
          {
            nixpkgs.config = {
              allowUnfree = true;
              cudaSupport = true;
              permittedInsecurePackages = [
                "librewolf-bin-148.0-1"
                "librewolf-bin-unwrapped-148.0-1"
                "openclaw-2026.5.7"
              ];
            };
          }
          # Unstable Nixpkgs Overlay
          (
            { config, pkgs, ... }:
            {
              nixpkgs.overlays = [
                (final: prev: {
                  unstable = import inputs.nixpkgs-unstable {
                    system = prev.stdenv.hostPlatform.system;
                    # Old System Definition
                    # system = prev.system;
                    config.allowUnfree = config.nixpkgs.config.allowUnfree or true;
                    config.cudaSupport = true;
                    config.permittedInsecurePackages = config.nixpkgs.permittedInsecurePackages or [
                      "librewolf-bin-148.0-1"
                      "librewolf-bin-unwrapped-148.0-1"
                      "openclaw-2026.5.7"
                    ];
                  };
                  plan9port-wayland = final.unstable.plan9port-wayland;
                })
              ];
            }
          )
          # CachyOS Kernel Overlay
          (
            { pkgs, ... }:
            {
              nixpkgs.overlays = [
                nix-cachyos-kernel.overlays.pinned
                inputs.millennium.overlays.default
                inputs.nixified-ai.overlays.comfyui
                inputs.nixified-ai.overlays.models
                inputs.nixified-ai.overlays.fetchers
              ];
            }
          )
          # Main NixOS Configuration
          (
            {
              config,
              pkgs,
              lib,
              ...
            }:
            {
              imports = [
                inputs.dms.nixosModules.dank-material-shell
                home-manager.nixosModules.home-manager
                ./hardware-configuration.nix
                inputs.nix-gaming.nixosModules.pipewireLowLatency
                flatpaks.nixosModules.default
              ];
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users = {
                  puppy = import ./modules/home/users/puppy.nix;
                  root = import ./modules/home/users/root.nix;
                };
                extraSpecialArgs = {
                  inherit inputs pkgs;
                };
                sharedModules = [
                  stylix.homeModules.stylix
                  nixmacs.homeManagerModules.default
                  nixvim.homeModules.nixvim
                  inputs.noctalia.homeModules.default # Noctalia
                  # vicinae.homeManagerModules.default # Vicinae
                  # inputs.mango.hmModules.mango # MangoWC
                  # inputs.naitre.hmModules.naitre # Naitre HUD
                  inputs.dms.homeModules.dank-material-shell # DMS Shell
                  inputs.spicetify-nix.homeManagerModules.default # Spicetify-Nix
                ];
                backupFileExtension =
                  let
                    timestamp = pkgs.runCommand "hm-backup-timestamp" { } ''
                      TZ="Europe/Berlin" date '+backup-%H:%M:%S@%d.%m.%Y' > $out
                    '';
                  in
                  builtins.readFile timestamp;
              };
              system.stateVersion = "25.11";
            }
          )
        ];
      };
      # Home-Manager
      homeConfigurations.puppy = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          stylix.homeModules.stylix
          ./modules/home/users/puppy.nix
        ];
      };
      homeConfigurations.root = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          ./modules/home/users/root.nix
          self.homeManagerModules.default
        ];
        extraSpecialArgs = {
          inherit inputs;
        };
      };
    };
}
