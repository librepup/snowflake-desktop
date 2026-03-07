{
  description = "NixOS Systems Flake for Desktop System (Snowflake)";

  inputs = {
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
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
            let
              synapsian = pkgs.callPackage ./files/packages/synapsian/default.nix { };
              karamarea = pkgs.callPackage ./files/packages/karamarea/default.nix { };
              templeos = pkgs.callPackage ./files/packages/templeosFont/default.nix { };
              gnutypewriter = pkgs.callPackage ./files/packages/gnutypewriter/default.nix { };
              osuLazerLatest = pkgs.callPackage ./files/packages/osuLazerLatest.nix { };
              urbitNcl = pkgs.callPackage ./files/packages/urbit/default.nix { };
              epdfinfoPkg = pkgs.callPackage ./files/packages/epdfinfo/default.nix { };
              cartographCF = pkgs.callPackage ./files/packages/cartographCF/default.nix { };
              spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
            in
            {
              imports = [
                inputs.dms.nixosModules.dank-material-shell # DMS Shell
                home-manager.nixosModules.home-manager
                nix-flatpak.nixosModules.nix-flatpak
                ./hardware-configuration.nix
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
                ];
                backupFileExtension = "backup";
              };
              # NixOS Configuration
              # 1TB Drive
              # Create Necessary Folders
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
              # Bootloader.
              boot.loader.systemd-boot.enable = true;
              boot.loader.efi.canTouchEfiVariables = true;
              boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
              # Networking
              networking = {
                wireless.enable = true;
                nameservers = [
                  "1.1.1.1"
                  "8.8.8.8"
                ];
                networkmanager.insertNameservers = [
                  "1.1.1.1"
                  "8.8.8.8"
                ];
              };
              services.udev = {
                packages = [ pkgs.util-linux ];
                extraRules = ''
                  # Wacom CTH-480 for OpenTabletDriver (OTD)
                  SUBSYSTEM=="hidraw", ATTRS{idVendor}=="056a", ATTRS{idProduct}=="0302", MODE="0666", GROUP="plugdev"
                '';
              };
              # Guix
              services.guix = {
                enable = true;
                substituters = {
                  urls = [
                    "https://bordeaux.guix.gnu.org"
                    "https://ci.guix.gnu.org"
                    "https://berlin.guix.gnu.org"
                    "https://substitutes.nonguix.org"
                  ];
                };
              };
              # Enable networking
              networking = {
                networkmanager.enable = true;
                hostName = "snowflake";
              };
              # Set your time zone.
              time.timeZone = "Europe/Berlin";
              # Select internationalisation properties.
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
              hardware.graphics = {
                enable = true;
              };
              # Tablet Support
              hardware.uinput.enable = true;
              boot.kernelModules = [ "uinput" ];
              boot.kernelParams = [
                "nvidia-drm.modeset=1"
                "nvidia-drm.fbdev=0"
              ];
              boot.initrd.kernelModules = [
                "nvidia"
                "nvidia_modeset"
                "nvidia_uvm"
                "nvidia_drm"
              ];
              hardware.opentabletdriver = {
                enable = true;
              };
              programs.ssh.askPassword = lib.mkForce "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
              programs = {
                mango.enable = true;
                naitre.enable = true;
                xwayland.enable = true;
              };
              services = {
                desktopManager = {
                  gnome.enable = true;
                  plasma6.enable = true;
                };
                displayManager = {
                  gdm.enable = false;
                  gdm.wayland = false;
                  sddm = {
                    enable = true;
                    wayland.enable = true;
                  };
                };
              };
              services.xserver = {
                videoDrivers = [ "nvidia" ];
                enable = true;
                xkb.layout = "us";
                xkb.variant = "colemak";
                windowManager.xmonad = {
                  enable = true;
                  enableContribAndExtras = true;
                };
                windowManager.i3 = {
                  enable = true;
                  extraPackages = with pkgs; [
                    dmenu
                    i3status
                    i3blocks
                    autotiling
                    polybarFull
                    picom
                    betterlockscreen
                    dunst
                    libnotify
                  ];
                  package = pkgs.i3-rounded;
                };
              };
              # Fonts
              fonts = {
                packages = with pkgs; [
                  cartographCF
                  synapsian
                  karamarea
                  gnutypewriter
                  noto-fonts
                  noto-fonts-cjk-sans
                  noto-fonts-emoji-blob-bin
                  liberation_ttf
                  fira-code
                  fira-code-symbols
                  dina-font
                  proggyfonts
                  uw-ttyp0
                  terminus_font
                  terminus_font_ttf
                  tamzen
                  powerline-fonts
                  twitter-color-emoji
                  iosevka
                  nerd-fonts.symbols-only
                  maple-mono.truetype
                  jonafonts.packages.${system}.jonafonts
                  tt2020 # Typewrite Font
                  templeos
                  emacs-all-the-icons-fonts # Required for Emacs all-the-icons
                ];
              };
              # Users
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
              users.users.puppy = {
                isNormalUser = true;
                shell = pkgs.zsh;
                description = "puppy";
                extraGroups = [
                  "networkmanager"
                  "wheel"
                  "dialout"
                  "plugdev"
                  "guixbuild"
                ];
                packages = with pkgs; [
                  qemu
                  quickemu
                  lynx
                  links2
                  w3m-full
                  kjv
                  emote
                  pulseaudio
                  whatsapp-electron
                  microsoft-edge
                  feh
                  cmus
                  alsa-utils
                  hyfetch
                  pridefetch
                  fastfetch
                  pfetch
                  discord
                  veracrypt
                  gimp3-with-plugins
                  flameshot
                  grim
                  grimblast
                  redshift
                  zathura
                  keepassxc
                  nil
                  nixfmt
                  qbittorrent
                  onefetch
                  kdePackages.qt5compat
                  sway-audio-idle-inhibit
                  imv
                  yazi
                  gamescope
                  vesktop
                  pciutils
                  xdotool
                  fd
                  picard # mp3 Tagging
                  krita
                  microfetch
                  imagemagick
                  yt-dlp
                  rofimoji
                  rofi
                  ardour
                  kdePackages.kdenlive
                  signal-desktop-bin
                  telegram-desktop
                  xclip
                  texliveFull
                  strawberry
                  blahaj
                  pavucontrol
                  zip
                  p7zip
                  unzip
                  unrar
                  appimage-run
                  rsync
                  zenmap
                  zerotierone
                  gparted
                  parted
                  jq
                  translate-shell
                  progress
                  openssl
                  coreutils-full
                  nix-prefetch-scripts
                  obs-studio
                  libreoffice
                  xfce.thunar
                  xfce.tumbler
                  gnome-shell-extensions
                  kew # Terminal Music Player with Cover Preview
                  hfsprogs # For Apple HFS+ Filesystems
                  ntfs3g # NTFS Filesystem Support
                  cryptsetup # LUKS Encryption
                  testdisk # File Recovery Utilities
                  encfs # Create Encrypted Folders
                  usbutils
                  websocat
                  gnome-font-viewer
                  fontforge-gtk
                  fontpreview
                  # Arduino
                  xorg.xkbutils
                  xorg.xrandr
                  xorg.xprop
                  xorg.xwininfo
                  arduino-ide
                  # Wine
                  wineWowPackages.full
                  winetricks
                  # Games
                  ace-of-penguins
                  kdePackages.kpat
                  azahar # 3DS Emulator
                  ryubing # Switch Emulator
                  skyemu # GameBoy Advanced Emulator
                  prismlauncher # Minecraft
                  # Networks
                  librewolf-bin # For I2P
                  tor-browser # For Tor
                  # Rust
                  cargo
                  rustc
                  rustfmt
                  clippy
                  rust-analyzer
                  gcc
                  libgcc
                  rustlings
                  # XMonad
                  xmobar
                  # Niri
                  wf-recorder
                  wtype
                  swaybg
                  waybar
                  swayidle
                  hyprlock
                  swaylock-fancy
                  wlsunset
                  wofi
                  mako
                  wlr-randr
                  xwayland
                  xwayland-satellite
                  slurp
                  sway-contrib.grimshot
                  hyprpicker
                  wl-clipboard
                  brightnessctl
                  playerctl
                  wireplumber
                  gammastep
                  xdg-desktop-portal
                  xdg-desktop-portal-gtk
                  xdg-desktop-portal-wlr
                  hyprshot
                  # Alternative Programs
                  eza
                  bat
                  zoxide
                  bottom
                  bandwhich
                  pokeget-rs
                  ripgrep
                  ripgrep-all
                  clock-rs
                ];
              };
              # Programs
              programs = {
                zsh = {
                  enable = true;
                  enableCompletion = true;
                  autosuggestions.enable = true;
                  syntaxHighlighting.enable = true;
                  shellAliases = {
                    # Basics
                    cd = "z $@";
                    cdi = "zi $@";
                    q = "exit";
                    ol = "sh -c 'ls $@'";
                    ols = "sh -c 'ls $@'";
                    ola = "sh -c 'ls -r -A $@'";
                    l = "eza --icons $@";
                    ls = "eza --icons $@";
                    la = "eza --icons -l -r -A -T -L=1 $@";
                    ll = "eza --icons -a $@";
                    cls = "clear $@";
                    # Nix Related
                    # Outdated Rebuild and Garbage Commands
                    #garbage = "sudo nix-collect-garbage -d $@";
                    #rebuild = "sudo nixos-rebuild switch $@";
                    # Old Home-Manager Inclusive Aliases
                    #garbage = "doas nix-collect-garbage -d && home-manager expire-generations '-2 days'";
                    #rebuild = "doas nixos-rebuild switch --flake /etc/nixos#snowflake && home-manager switch --flake /etc/nixos#puppy";
                    home-rebuild = "home-manager switch --flake /etc/nixos#puppy $@";
                    home-garbage = "home-manager expire-generations '-1 days'";
                    rebuild = "doas nixos-rebuild switch --flake /etc/nixos#snowflake $@";
                    garbage = "doas nix-collect-garbage -d $@";
                    ns = "nix-shell --run zsh $@";
                    nixbuild = "echo 'Did you mean `buildnix`?'";
                    repair = "doas nix-store --verify --repair $@";
                    nix-generations = "doas nix-env --list-generations --profile /nix/var/nix/profiles/system $@";
                    #generations = "echo -e 'NixOS Generations:\n' && doas nix-env --list-generations --profile /nix/var/nix/profiles/system && echo -e '\nHome-Manager Generations:\n' && home-manager generations";
                    generations = "echo -e 'NixOS Generations:\n' && doas nix-env --list-generations --profile /nix/var/nix/profiles/system && echo -e '\nHome-Manager Generations:\n' && ls -l ~/.local/state/nix/profiles/ | grep home-manager";
                    #home-generations = "home-manager generations $@";
                    home-generations = "ls -l ~/.local/state/nix/profiles/ | grep home-manager $@";
                    # Fetching
                    fetch = "echo -e 'mf => Microfetch\npf => Pridefetch\nhf => Hyfetch\nff => Fastfetch'";
                    hf = "hyfetch $@";
                    pf = "pridefetch -f trans --width 11 $@";
                    mf = "microfetch $@";
                    ff = "fastfetch $@";
                    gf = "fastfetch --pipe false --logo Guix | sed 's/NixOS 25.11 (Xantusia)/Guix System/g' $@";
                    pef = "pfetch $@";
                    of = "onefetch $@";
                    distro = "cat /etc/*-release | grep 'PRETTY_NAME' | cut -c 13- | sed 's/\"//g'";
                    lsbOsRelease = "lsb_release -sd $@";
                    # Editing
                    e = "nixmacs -nw $@";
                    ec = "emacsclient -c -nw $@";
                    vim = "nixmacs -nw $@";
                    # Downloading
                    mp3 = "yt-dlp -x --audio-format mp3 -o '%(uploader)s - %(title)s' $@";
                    # Extra
                    ripgrep = "rg $@";
                    oldgrep = "grep $@";
                    cargorun = "RUSTFLAGS='-Awarnings' cargo run";
                    fireswitch = "nix-shell -p firefox --run 'firefox -no-remote -ProfileManager' $@";
                    lsfind = "find . -name '$@'";
                    # Zipping
                    tarShow = "tar tvf $@";
                    tarUnzip = "tar xvf $@";
                    tarZip = "echo 'Arg1: Archive.tar.gz, Arg2: Full Path of the Folder';tar -czvf $@";
                    zipCreate = "echo 'Arg1: Archive.zip, Arg2: Folder/';zip -r $@";
                    # Applications
                    bible = "kjv $@";
                    img = "kitten icat --use-window-size 380,380,380,380 $@";
                    explorer = "yazi $@";
                    poke = "pokeget --hide-name $@";
                    weather = "curl wttr.in/Berlin $@";
                    wetter = "curl wttr.in/Berlin $@";
                    htop = "btm --theme nord $@";
                    iftop = "bandwhich $@";
                    gc = "git clone $@";
                    cat = "bat --style=plain --decorations=always --color=always --theme=base16 --pager=less --paging=auto --wrap=auto $@";
                    wp = "feh --bg-fill $@";
                    forcekill = "kill -9 $@";
                    size = "du -sh $@";
                    analogcity = "ssh lowlife@45.79.250.220 $@";
                    shreddy = "shred -z -u -v --iterations=1 $@";
                    wineosu = "WINEPREFIX=$HOME/.wine-osu wine64 $@";
                    winethirtytwo = "WINEPREFIX=$HOME/.wine-thirtytwo wine $@";
                    ipinfo = "curl ipinfo.io | jq .";
                    radminstart = "doas systemctl start zerotierone $@";
                    zerotierstart = "doas systemctl start zerotierone $@";
                    torstart = "doas systemctl start tor $@";
                    radminstop = "doas systemctl stop zerotierone $@";
                    zerotierstop = "doas systemctl stop zerotierone $@";
                    torstop = "doas systemctl stop tor $@";
                    radminstatus = "doas systemctl status zerotierone $@";
                    zerotierstatus = "doas systemctl status zerotierone $@";
                    torstatus = "doas systemctl status tor $@";
                    cp = "rsync -ah --progress $1 $2";
                    encryptunmount = "echo \"encryptunmount /mnt/Decrypted\";fusermount -u $1";
                    encryptmount = "echo \"encryptmount /mnt/Encrypted /mnt/Decrypted\";encfs $1 $2";
                    clock = "clock-rs --color red --hide-seconds --bold --fmt '%A, %d.%m.%Y'";
                    cleanflatpak = "flatpak uninstall --unused";
                    guix-garbage = "guix gc $@";
                    guix-update = "guix pull && guix package --upgrade && guix gc $@";
                    search = "nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history $@";
                  };
                  shellInit = ''
                    unset -m EMACSLOADPATH
                    unalias -m 9

                    if [ -d "$HOME/.scripts/shell" ]; then
                      for script in "$HOME/.scripts/shell"/*; do
                        [ -f "$script" ] && source "$script"
                      done
                    fi

                    # emacsclient
                    ec() {
                      guix shell emacs-pgtk -- emacsclient -c -nw "$@"
                    }

                    # c d-Directory Function
                    function c() {
                      if [[ $1 == d* ]]; then
                        local target="''${1#d}"
                        builtin cd "$target"
                      else
                        echo "Usage: c d<directory>"
                      fi
                    }

                    # Echo Out File
                    echoout() {
                      echo "$(<"$1")"
                    }

                    # Nix and Home Generations
                    nixgens() {
                      NixGens=$(doas nix-env --list-generations --profile /nix/var/nix/profiles/system)
                      HomeGens=$(home-manager generations)
                      echo -e "NixOS Generations:\n$NixGens\nHome-Manager Generations:\n$HomeGens\n"
                    }

                    # Nix Clean
                    clean() {
                      doas nix-store --gc
                      doas nix-collect-garbage -d
                      nix store optimise
                    }

                    # Ports
                    ports() {
                      doas ss -tulnp | awk '
                        NR==1 {print; next}
                        {printf "%-5s %-20s %-30s %-30s %s\n", $1, $5, $6, $7, $9}'
                    }

                    # File Edit Picker
                    edit() {
                      local file
                      file=$(fzf) || return
                      emacs -nw "$file"
                    }

                    # Translate Text to English
                    translate() {
                      trans -brief :"en" "$@"
                    }

                    # Progress Bar Move
                    move() {
                      command mv "$@" &
                      pid=$!
                      progress -mp $pid
                      wait $pid
                    }

                    # Trash
                    trash() {
                      local file="$1"
                      local dir="$HOME/.local/share/Trash/files"
                      mkdir -p "$dir"
                      mv "$file" "$dir"
                      echo "Moved $file to Trash."
                    }

                    # Serve HTTP Server in Current Directory
                    serve() {
                      local port
                      if [ -z "$1" ]; then
                        port=8000
                      else
                        port="$1"
                      fi
                      nix-shell -p python3 --run "python3 -m http.server "$port""
                    }

                    # Backup Files
                    backup() {
                      if [ -z "$1" ]; then
                        echo "Usage: backup <File>"
                        return 1
                      fi
                      cp -r "$1" "$1.$(date +%Y%m%d_%H%M%S).backup"
                    }

                    getNineBinPath() {
                      export NINEBINPATH=$(ls -la $(which 9) | awk '{print $9}' | sed "s/\/bin\/9/\/plan9\/bin/g")
                    }

                    # Guix Initialization and Setup
                    GUIX_PROFILE="$HOME/.config/guix/current"
                    . "$GUIX_PROFILE/etc/profile"
                    GUIX_PROFILE="$HOME/.guix-profile"
                    . "$GUIX_PROFILE/etc/profile"
                    GUIX_PROFILE="/var/guix/profiles/per-user/puppy/guix-profile"
                    . "$GUIX_PROFILE/etc/profile"
                    source "$GUIX_PROFILE/etc/profile"

                    # Initialize Zoxide (cd alternative).
                    eval "$(zoxide init zsh)"
                  '';
                  ohMyZsh = {
                    enable = true;
                    theme = "";
                  };
                  promptInit = ''
                    unset -m EMACSLOADPATH
                    unalias -m 9
                    if [[ -n "$IN_NIX_SHELL" ]]; then
                      PROMPT='  (shell) %~ '
                    elif [[ -n "$GUIX_ENVIRONMENT" ]]; then
                      PROMPT='  (shell) %~ '
                    else
                      PROMPT='  %~ '
                    fi
                    if [ -d "$HOME/.scripts/shell" ]; then
                      for script in "$HOME/.scripts/shell"/*; do
                        [ -f "$script" ] && source "$script"
                      done
                    fi
                  '';
                };
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
                  };
                };
              };

              environment.interactiveShellInit = ''
                unset EMACSLOADPATH
              '';

              # Wayland Session Variables
              environment.sessionVariables = {
                LIBVA_DRIVER_NAME = "nvidia";
                GBM_BACKEND = "nvidia-drm"; # In case of issues, try removing this variable, as it's not required on newer 580 Drivers.
                __GLX_VENDOR_LIBRARY_NAME = "nvidia";
                WLR_NO_HARDWARE_CURSORS = "1";
                NIXOS_OZONE_WL = "1";
              };

              # System Packages
              environment.systemPackages =
                with pkgs;
                let
                  emacs-wayland = pkgs.writeShellScriptBin "emacs-wayland" ''
                    exec ${pkgs.emacs.override { withPgtk = true; }}/bin/emacs "$@"
                  '';
                  emacs-x11 = pkgs.writeShellScriptBin "emacs-x11" ''
                    exec ${pkgs.emacs}/bin/emacs "$@"
                  '';
                in
                [
                  nickel
                  urbitNcl
                  epdfinfoPkg
                  libelf
                  gnumake
                  gcc
                  nix-alien
                  nix-search-tv.packages.x86_64-linux.default
                  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
                  wget
                  emacs-wayland
                  emacs-x11
                  irssi
                  home-manager
                  osuLazerLatest
                ];
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

              programs.dank-material-shell = {
                enable = true;
                quickshell.package = pkgs.unstable.quickshell;
                dgop.package = inputs.dgop.packages.${pkgs.system}.default;
              };

              programs.fzf.fuzzyCompletion = true;

              # Services
              services = {
                yggdrasil = {
                  enable = false;
                  persistentKeys = false;
                  settings = {
                    Peers = [
                      "tls://n.ygg.yt:443"
                      "tls://b.ygg.yt:443"
                      "tcp://s-fra-0.sergeysedoy97.ru:65533"
                      "tcp://yggdrasil.su:62486"
                      "tls://yggdrasil.su:62586"
                      "tls://helium.avevad.com:1337"
                      "tcp://ygg.mkg20001.io:80"
                      "tcp://bode.theender.net:42069"
                    ];
                  };
                };
                i2pd = {
                  enable = false;
                  address = "127.0.0.1";
                  proto = {
                    # 127.0.0.1:4447 on SOCKS5 Firefox Network settings.
                    # Leave HTTP and HTTPS Proxies blank.
                    http.enable = true;
                    socksProxy.enable = true;
                    httpProxy.enable = true;
                    sam.enable = true;
                  };
                };
                tor = {
                  enable = true;
                  client = {
                    enable = true;
                  };
                  torsocks = {
                    enable = true;
                  };
                };
              };
              systemd.services.tor.wantedBy = lib.mkForce [ ];

              programs.gnupg.agent = {
                enable = true;
                enableSSHSupport = true;
              };

              services.displayManager.defaultSession = "none+xmonad";
              hardware.nvidia = {
                package = config.boot.kernelPackages.nvidiaPackages.stable;
                modesetting.enable = true;
                powerManagement.enable = false;
                powerManagement.finegrained = false;
                open = false;
                nvidiaSettings = true;
              };
              # Enable CUPS to print documents.
              services.printing.enable = true;
              services.xserver.xrandrHeads = [
                {
                  output = "HDMI-0";
                  monitorConfig = ''
                    Option "Mode" "1920x1080"
                    Option "Rate" "144"
                    Option "Primary" "true"
                    Option "Position" "0 0"
                  '';
                }
                {
                  output = "DP-0";
                  monitorConfig = ''
                    Option "Mode" "2560x1440"
                    Option "Rate" "60"
                    Option "Position" "1920 0"
                  '';
                }
              ];
              # Enable sound with pipewire.
              services.pulseaudio.enable = false;
              security = {
                rtkit.enable = true;
                doas = {
                  enable = true;
                  wheelNeedsPassword = true;
                  extraRules = [
                    {
                      groups = [ "wheel" ];
                      noPass = false;
                      keepEnv = true;
                      persist = true;
                    }
                  ];
                };
              };
              services.pipewire = {
                enable = true;
                alsa.enable = true;
                alsa.support32Bit = true;
                pulse.enable = true;
                # If you want to use JACK applications, uncomment this
                #jack.enable = true;
                # use the example session manager (no others are packaged yet so this is enabled by default,
                # no need to redefine it in your config for now)
                #media-session.enable = true;
              };
              # VirtualBox
              virtualisation.virtualbox.host.enable = true;
              users.extraGroups.vboxusers.members = [ "puppy" ];
              # Flatpak
              services.flatpak = {
                enable = true;
                update.onActivation = true;
                remotes = [
                  {
                    name = "flathub";
                    location = "https://flathub.org/repo/flathub.flatpakrepo";
                  }
                ];
                packages = [
                  {
                    appId = "org.vinegarhq.Sober";
                    origin = "flathub";
                  }
                ];
              };
              # Wine/Windows
              services.samba = {
                enable = true;
                winbindd.enable = true;
              };
              # Radmin/Hamachi/ZerotierOne
              services.zerotierone = {
                enable = false;
                port = 9993;
                joinNetworks = [
                  "88c5b1f3394e489b"
                  "b103a835d294de2a"
                ];
              };
              # Nix Settings
              nix = {
                settings = {
                  substituters = [
                    "https://attic.xuyh0120.win/lantian"
                  ];
                  trusted-public-keys = [
                    "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=""lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
                  ];
                  auto-optimise-store = true;
                  experimental-features = [
                    "nix-command"
                    "flakes"
                  ];
                };
              };

              #systemd.services.zerotierone.wantedBy = lib.mkForce [ ];
              nixpkgs.config = {
                allowUnfree = true;
                permittedInsecurePackages = [
                  "librewolf-bin-148.0-1"
                  "librewolf-bin-unwrapped-148.0-1"
                ];
              };
              # Niri
              programs.niri = {
                enable = true;
              };
              # Tmux
              programs.tmux = {
                enable = true;
                clock24 = true;
                extraConfig = ''
                  set -g @tmux-gruvbox 'dark'
                  set -g status-left '  %H:%M '
                  set -g status-right ' 󰭨 %d.%m.%Y '
                  unbind C-b
                  set-option -g prefix C-c
                  bind-key C-c send-prefix
                  bind v split-window -v
                  bind 2 split-window -v
                  bind h split-window -h
                  bind 3 split-window -h
                  bind 0 kill-pane
                  set-option -g default-shell /run/current-system/sw/bin/zsh
                '';
                plugins = [
                  pkgs.tmuxPlugins.gruvbox
                ];
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
