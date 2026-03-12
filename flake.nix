{
  description = "NixOS Systems Flake for Desktop System (Snowflake)";
  inputs = {
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-gaming.url = "github:fufexan/nix-gaming";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/v0.6.0";
    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:librepup/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vicinae.url = "github:vicinaehq/vicinae";
    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-search-tv.url = "github:3timeslazy/nix-search-tv";
    mango = {
      url = "github:DreamMaoMao/mango"; # Add "?ref=vertical-stack" to the url end for specific branch.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    naitre = {
      url = "github:librepup/NaitreHUD";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    jonafonts.url = "github:librepup/jonafonts";
    # Run 'doas nix flake update nixmacs' after changes to
    # the repository to rebuild with latest changes!
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
    jonabron.url = "github:librepup/jonabron";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nix-flatpak,
      stylix,
      nix-index-database,
      nixmacs,
      nixvim,
      noctalia,
      nix-alien,
      nix-search-tv,
      astal,
      vicinae,
      mango,
      naitre,
      nixpkgs-unstable,
      dms,
      dgop,
      spicetify-nix,
      jonafonts,
      nix-cachyos-kernel,
      nix-gaming,
      plasma-manager,
      jonabron,
      ...
    }:
    let
      system = "x86_64-linux";
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
          mango.nixosModules.mango
          naitre.nixosModules.naitre
          inputs.spicetify-nix.nixosModules.default
          (
            { config, pkgs, ... }:
            {
              nixpkgs.overlays = [
                (final: prev: {
                  unstable = import inputs.nixpkgs-unstable {
                    system = prev.system;
                    config.allowUnfree = config.nixpkgs.config.allowUnfree or false;
                  };
                })
              ];
            }
          )
          (
            { pkgs, ... }:
            {
              nixpkgs.overlays = [ nix-cachyos-kernel.overlays.pinned ];
            }
          )
          (
            {
              config,
              pkgs,
              lib,
              ...
            }:
            {
              imports = [
                inputs.dms.nixosModules.dank-material-shell # DMS Shell
                home-manager.nixosModules.home-manager
                nix-flatpak.nixosModules.nix-flatpak
                ./hardware-configuration.nix
                inputs.nix-gaming.nixosModules.pipewireLowLatency
              ];
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.puppy = import ./home.nix;
                extraSpecialArgs = {
                  inherit inputs pkgs;
                };
                sharedModules = [
                  stylix.homeModules.stylix
                  nixmacs.homeManagerModules.default
                  nixvim.homeModules.nixvim
                  inputs.noctalia.homeModules.default # Noctalia
                  vicinae.homeManagerModules.default # Vicinae
                  inputs.mango.hmModules.mango # MangoWC
                  inputs.naitre.hmModules.naitre # Naitre HUD
                  inputs.dms.homeModules.dank-material-shell # DMS Shell
                  inputs.spicetify-nix.homeManagerModules.default # Spicetify-Nix
                  plasma-manager.homeModules.plasma-manager
                ];
                backupFileExtension = "backup";
              };
              # NixOS Configuration
              # Create Folders
              systemd.tmpfiles.rules = [
                "d /extra 0775 puppy users -"
                "d /mnt 0775 puppy users -"
                "d /mnt/SteamLibrary 0775 puppy users -"
                "d /run/nvidia-xdriver 0777 root root -"
                "d /mountables 0755 root root -"
                "d /mountables/genesis 0755 root root -"
                "d /mountables/exodus 0755 root root -"
                "d /mountables/leviticus 0755 root root -"
                "d /mountables/deuteronomy 0755 root root -"
                "d /mountables/ezekiel 0755 root root -"
              ];
              # Handle "/mnt"
              fileSystems."/mnt" = {
                device = "/dev/disk/by-uuid/a30aac38-dff9-45ca-9719-d8455016d774";
                fsType = "ext4";
                options = [
                  "defaults"
                  "nofail"
                ];
              };
              # Firmware
              hardware.enableRedistributableFirmware = true;
              # Bootloader
              boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
              # TimeZone
              time.timeZone = "Europe/Berlin";
              # Locales
              i18n.defaultLocale = "en_US.UTF-8";
              i18n.extraLocaleSettings = {
                LC_ADDRESS = "de_DE.UTF-8";
                LC_IDENTIFICATION = "de_DE.UTF-8";
                LC_MEASUREMENT = "de_DE.UTF-8";
                LC_MONETARY = "de_DE.UTF-8";
                LC_NAME = "de_DE.UTF-8";
                LC_NUMERIC = "de_DE.UTF-8";
                LC_PAPER = "de_DE.UTF-8";
                LC_TELEPHONE = "de_DE.UTF-8";
                LC_TIME = "de_DE.UTF-8";
              };
              # Programs
              programs.ssh.askPassword = lib.mkForce "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
              programs = {
                mango.enable = true;
                naitre.enable = true;
                xwayland.enable = true;
              };
              # Programs
              programs = {
                firefox.enable = true;
                steam = {
                  enable = true;
                  remotePlay.openFirewall = true;
                  dedicatedServer.openFirewall = true;
                  localNetworkGameTransfers.openFirewall = true;
                  extraCompatPackages = with pkgs; [
                    proton-ge-bin
                  ];
                };
                less.enable = true;
                git = {
                  enable = true;
                };
                bash = {
                  completion.enable = true;
                  enableLsColors = true;
                  promptInit = ''
                    PS1="\h:\w \u\$ "
                  '';
                  shellAliases = {
                    q = "exit";
                    l = "ls $@";
                    la = "ls -r -A $@";
                    garbage = "sudo nix-collect-garbage -d $@";
                    rebuild = "sudo nixos-rebuild switch $@";
                    hf = "hyfetch $@";
                    e = "emacs -nw $@";
                    size = "du -sh $@";
                    vim = "emacs -nw $@";
                    mf = "microfetch $@";
                    wp = "feh --bg-fill $@";
                  };
                };
              };
              # XDG
              xdg = {
                mime = {
                  enable = true;
                  defaultApplications = {
                    "image/png" = "feh.desktop";
                    "image/jpeg" = "feh.desktop";
                    "image/jpg" = "feh.desktop";
                    "image/webp" = "feh.desktop";
                    "video/mp4" = "mpv.desktop";
                    "video/webm" = "mpv.desktop";
                    "video/mkv" = "mpv.desktop";
                    "video/mov" = "mpv.desktop";
                    "application/pdf" = "zathura.desktop";
                    "inode/directory" = "thunar.desktop";
                    "text/html" = "firefox.desktop";
                  };
                };
              };
              environment.interactiveShellInit = ''
                unset EMACSLOADPATH
              '';
              environment.variables = {
                EDITOR = "nixmacs";
                VISUAL = "nixmacs";
                PAGER = "less";
                TERMINAL = "kitty";
              };
              programs.nix-ld.enable = true;
              programs.thunar = {
                enable = true;
                plugins = with pkgs.xfce; [
                  thunar-media-tags-plugin
                  thunar-archive-plugin
                ];
              };
              # DMS
              programs.dank-material-shell = {
                enable = true;
                quickshell.package = pkgs.unstable.quickshell;
                dgop.package = inputs.dgop.packages.${pkgs.system}.default;
              };
              programs.fzf.fuzzyCompletion = true;
              # GPG
              programs.gnupg.agent = {
                enable = true;
                enableSSHSupport = true;
              };
              # Printing
              services.printing.enable = true;
              # Wine/Windows
              services.samba = {
                enable = true;
                winbindd.enable = true;
              };
              # Niri
              programs.niri = {
                enable = true;
              };
              # Ensure the same basic flake options you already enable
              system.stateVersion = "25.11"; # Did you read the comment?
            }
          )
        ];
      };
      # ChatGPT Firefox Stylix Fix BEGIN
      homeConfigurations.puppy = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          stylix.homeModules.stylix
          ./home.nix
        ];
      };
      # ChatGPT Firefox Stylix Fix END
    };
}
