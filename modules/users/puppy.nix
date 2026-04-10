{ config, pkgs, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  bundleBrowsers = with pkgs; [
    librewolf-bin
    tor-browser
    lynx
    links2
    w3m-full
    microsoft-edge
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    floorp-bin
  ];
  bundleRust = with pkgs; [
    cargo
    rustc
    rustfmt
    clippy
    rust-analyzer
    gcc
    libgcc
    rustlings
  ];
  bundleWayland = with pkgs; [
    grim
    grimblast
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
    gammastep
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
    hyprshot
    sway-audio-idle-inhibit
    eww
    xclicker
  ];
  bundleFetchers = with pkgs; [
    microfetch
    hyfetch
    pridefetch
    fastfetch
    pfetch
    onefetch
  ];
  bundleVSTs = with pkgs; [
    yabridge
    yabridgectl
    oxefmsynth
    bespokesynth-with-vst2
    ninjas2
    zam-plugins
    vaporizer2
    surge
    lsp-plugins
  ];
  bundleDAWs = with pkgs; [
    ardour
    zrythm
    non
    muse
  ];
  bundleAudioUtilities = with pkgs; [
    playerctl
    wireplumber
    qpwgraph
    pulseaudio
    pavucontrol
    alsa-utils
    id3v2
    helvum
    volctl
    lyrebird
    easyeffects
  ];
  bundleMessaging = with pkgs; [
    signal-desktop-bin
    telegram-desktop
    whatsapp-electron
    discord
    vesktop
    ripcord
    equibop
    element-desktop
  ];
  bundleGames = with pkgs; [
    ace-of-penguins
    kdePackages.kpat
    prismlauncher
    itgmania
    etterna
    inputs.jonabron.packages.x86_64-linux.gobm
  ];
  bundleEmulators = with pkgs; [
    azahar
    ryubing
    skyemu
    waydroid-helper
    cage
    weston
  ];
  bundleGraphicsDesign = with pkgs; [
    gimp3-with-plugins
    krita
    krita-plugin-gmic
    imagemagick
    blender
    exiftool
    upscaler
  ];
  bundleMusicPlayers = with pkgs; [
    spotdl
    strawberry
    kew
    cmus
    spotify-tray
  ];
  bundleWine = with pkgs; [
    wineWowPackages.yabridge
    winetricks
  ];
  bundleArchivers = with pkgs; [
    zip
    p7zip
    unzip
    unrar
    ntfs3g
    hfsprogs
    cryptsetup
    testdisk
    encfs
    xarchiver
    file-roller
  ];
  bundleVideoProduction = with pkgs; [
    obs-studio
    kdePackages.kdenlive
    kdePackages.ffmpegthumbs
    simplescreenrecorder
  ];
  bundleWeb = with pkgs; [
    httrack
    suckit
    wayback_machine_downloader
    wget2
    pastebinit
  ];
  bundleImageViewers = with pkgs; [
    feh
    xfce.tumbler
  ];
  bundleExplorers = with pkgs; [
    xfce.thunar
    yazi
  ];
  bundleNode = with pkgs; [
    nodejs_24
  ];
  bundleShells = with pkgs; [
    powershell
    xonsh
    nushell
    rc-9front
    cat9
  ];
  bundleGeneralUtilities = with pkgs; [
    progress
    openssl
    parted
    gparted
    rsync
    usbutils
    websocat
    xorg.xkbutils
    xorg.xkbprint
    ghostscript
    xorg.xrandr
    xorg.xprop
    xorg.xwininfo
    eza
    bat
    zoxide
    bottom
    bandwhich
    ripgrep
    ripgrep-all
    clock-rs
    ffmpeg-full
    coreutils-full
    xclip
    xdotool
    pciutils
    fd
    imv
    jq
    xev
    nix-search-cli
    manix
    xorg.xkill
    devour
    systemdgenie
    xmodmap
    xbindkeys
    killall
    xdo
    powershell
    ghidra-bin
  ];
  bundleNetworking = with pkgs; [
    dhcpcd
    networkmanagerapplet
    networkmanager_dmenu
    wpa_supplicant
    protonvpn-gui
    riseup-vpn
  ];
  bundleThemes = with pkgs; [
    whitesur-gtk-theme
    whitesur-icon-theme
    chicago95
    windows10-icons
    inputs.jonabron.packages.x86_64-linux.windows-xp-theme
    inputs.jonabron.packages.x86_64-linux.windows-vista-theme
    inputs.jonabron.packages.x86_64-linux.revista
    inputs.jonabron.packages.x86_64-linux.xptheme
    inputs.jonabron.packages.x86_64-linux.winxp-icons
    inputs.jonabron.packages.x86_64-linux.diinki-aero
  ];
  bundleKeyboard = with pkgs; [
    keyboard-layout-editor
    kalamine
    xorg.xkbcomp
  ];
in
{
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
      "libvirtd"
      "input"
      "ydotool"
      "render"
      "input-remapper"
    ];
    packages = with pkgs; [
      kitty
      inputs.jonabron.packages.x86_64-linux.keyboard-layout-exporter
      inputs.jonabron.packages.x86_64-linux.jonabar
      inputs.nix-init.packages.x86_64-linux.default
      inputs.jonabron.packages.x86_64-linux.momoisay
      lxappearance
      espeak
      inputs.jonabron.packages.x86_64-linux.urbit
      kdePackages.karousel
      plasmusic-toolbar
      libsForQt5.qtstyleplugin-kvantum
      libsForQt5.qt5ct
      lutris
      bottles
      (pkgs.callPackage "${inputs.jonabron}/nix/packages/notitg/default.nix" { })
      inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-stable
      qemu
      quickemu
      kjv
      emote
      veracrypt
      flameshot
      redshift
      zathura
      keepassxc
      nil
      nixfmt
      qbittorrent
      kdePackages.qt5compat
      picard
      yt-dlp
      rofimoji
      rofi
      texliveFull
      blahaj
      appimage-run
      zenmap
      zerotierone
      translate-shell
      nix-prefetch-scripts
      libreoffice
      gnome-shell-extensions
      gnome-font-viewer
      fontforge-gtk
      fontpreview
      arduino-ide
      xmobar
      pokeget-rs
    ]
    ++ bundleBrowsers
    ++ bundleRust
    ++ bundleWayland
    ++ bundleFetchers
    ++ bundleVSTs
    ++ bundleDAWs
    ++ bundleAudioUtilities
    ++ bundleMessaging
    ++ bundleGames
    ++ bundleEmulators
    ++ bundleGraphicsDesign
    ++ bundleMusicPlayers
    ++ bundleWine
    ++ bundleArchivers
    ++ bundleVideoProduction
    ++ bundleGeneralUtilities
    ++ bundleNetworking
    ++ bundleImageViewers
    ++ bundleKeyboard
    ++ bundleThemes
    ++ bundleShells
    ++ bundleNode
    ++ bundleExplorers;
  };
}
