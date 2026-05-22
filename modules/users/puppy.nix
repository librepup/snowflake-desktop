{
  config,
  pkgs,
  inputs,
  ...
}:
let
  # Kate Wrapper for Editing NixOS Configuration Files
  kate-edit-nixos = pkgs.writeShellScriptBin "kedit-nixos" ''
    exec ${pkgs.kdePackages.kate}/bin/kate /etc/nixos "$@"
  '';
  # Kate Wrapper for Editing XMonad Configuration Files
  kate-edit-xmonad = pkgs.writeShellScriptBin "kedit-xmonad" ''
    exec ${pkgs.kdePackages.kate}/bin/kate $HOME/.xmonad "$@"
  '';
  # Text-File Containing the Path to the WideVine DRM Utility
  widevine-path-location = pkgs.writeShellScriptBin "widevine-path-location" ''
    echo "${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm"
  '';
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system}; # Define Spicetify-Nix Packages
  bundleBrowsers = with pkgs; [
    google-chrome # Google's Web-Browser
    librewolf-bin # LibreWolf Firefox Forked Web-Browser with a Focus on Privacy
    tor-browser # Tor Browser
    lynx # CLI Web-Browser
    links2 # CLI Web-Browser
    w3m-full # CLI Web-Browser
    #microsoft-edge # Microsoft's Edge Web-Browser
    unstable.microsoft-edge # Microsoft's Edge Web-Browser (Unstable Channel)
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default # Zen Firefox Forked Web Browser
    floorp-bin # Floorp Firefox Forked Web-Browser
    filezilla # GUI FTP Client
    inputs.helium.packages.x86_64-linux.default # Helium Chromium Based Web Browser
    inputs.jonabron.packages.x86_64-linux.pybrowse # Python-Based GUI Browser Selector/Opener/Launcher
    netflix # GUI Wrapper for Netflix based on Chrome
    vivaldi # Vivaldi Web-Browser
    vivaldi-ffmpeg-codecs # Vivaldi Web-Browser Codecs
    nur.repos.hythera.waterfox-bin # WaterFox Firefox Based Web-Browser
    nur.repos.bandithedoge.thorium-bin # Throium Web-Browser
    thunderbird-bin # ThunderBird E-Mail Client Suite
    widevine-cdm # WideVine DRM Support for Netflix and related Services
    widevine-path-location # WideVine DRM Support for Netflix and related Services
  ];
  bundleRust = with pkgs; [
    # Various Rust Related Utilities
    cargo
    rustc
    rustfmt
    clippy
    rust-analyzer
    gcc
    libgcc
    rustlings
  ];
  bundleApple = with pkgs; [
    libimobiledevice
    ifuse
    gvfs
  ];
  bundleAI = with pkgs; [
    ollama-vulkan # Vulkan-Enabled Local LLM/AI Utility
  ];
  bundleFlatpak = with pkgs; [
    # Various Flatpak Related Utilities
    warehouse
    bazaar
    flatpak-xdg-utils
    kdePackages.flatpak-kcm
  ];
  bundleHaskell = with pkgs; [
    ghc # Haskell Compiler
    stack # Haskell Package/Module Management Utility
    cabal-install # Haskell Cabal Installer
  ];
  bundleWayland = with pkgs; [
    # Various Wayland Related Packages
    grim
    wlprop
    wayneko
    nirius
    xwayland-run
    wl-color-picker
    fuzzel
    wdisplays
    hyprmagnifier
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
    xdg-desktop-portal-gnome
    hyprshot
    sway-audio-idle-inhibit
  ];
  bundleFetchers = with pkgs; [
    microfetch # Minimalist System-Fetcher Utility
    hyfetch # System-Fetcher Utility with Pride Flags!
    pridefetch # Pride-Flag Themed System-Fetcher Utility
    fastfetch # Successor to NeoFetch
    pfetch # Minimalist Fetching Utility
    onefetch # GitHub Repository Fetching Utility
  ];
  bundleVSTs = with pkgs; [
    # Various Audio Production VST Plugins
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
    ardour # Ardour Audio Production DAW
    zrythm # ZRythm Audio Production DAW
    non # Non-DAW Audio Production DAW
    muse # Muse Audio Production DAW
  ];
  bundleAudioUtilities = with pkgs; [
    playerctl
    mamba
    ciano
    soundconverter
    glava
    wireplumber
    qpwgraph # Visualize your Audio Driver(s) in a GUI Graph
    pulseaudio
    pavucontrol # GUI Volume Control Software
    audacity # Audio Editing Software
    alsa-utils
    pwvucontrol
    id3v2 # Simple CLI Tagging Utility for Audio Files
    helvum
    volctl
    lyrebird
    easyeffects # Effects Suite, Voice Changer, and Audio Enhancement Utility for PipeWire Microphones
  ];
  bundleMessaging = with pkgs; [
    signal-desktop-bin # Signal Desktop Chatting Client
    telegram-desktop # Telegram Desktop Chatting Client
    whatsapp-electron # Electron Wrapper for WhatsApp Web
    discord # Generic Discord Client
    betterdiscordctl # Manage your BetterDiscord Installation from the Command Line
    vesktop # Classic Vencord Desktop Discord Client
    ripcord # Custom Third-Party Discord Client with a new UI
    equibop # Feature-Rich Discord Client with support for almost all Plugin Types
    element-desktop # Matrix Client for Linux
    goofcord # Privacy Focus, Enhanced Discord Client with Theme and Plugin Support
  ];
  bundleEmulators = with pkgs; [
    azahar
    ryubing
    skyemu
    waydroid-helper # Helper Utility for Waydroid Android Containers
    cage
    weston # Nested Wayland Compositor similar to Xephyr
  ];
  bundleVirtualization = with pkgs; [
    # Various Virtualization and Containerization Tools
    dive
    podman-tui
    docker-compose
    x11docker
    xhost
    nx-libs
  ];
  bundleGraphicsDesign = with pkgs; [
    gimp3-with-plugins # GNU Image Manipulation Software
    krita # Image Editing Software
    krita-plugin-gmic # Plugin for Krita
    imagemagick
    blender # 3D Modelling Software
    exiftool # Read, Modify, and Delete EXIF Data from Images
    upscaler # Upscale Images with the usage of AI
    themix-gui
  ];
  bundleMusicPlayers = with pkgs; [
    spotdl # Spotify Track Downloader
    strawberry # Classic GUI Music Player
    kew # CLI Music Player with Album and Song Cover Previews
    cmus # CLI Music Player
    spotify-tray # Spotify Launcher with Integrated Tray-Icon
    tauon # Beautiful Music Player
  ];
  bundleWineAndGames = with pkgs; [
    wineWowPackages.yabridge # Wine Package optimized for Audio Production and VST Usage
    winetricks # Tweak and Extend WinePrefixes
    faugus-launcher
    inputs.jonabron.packages.x86_64-linux.gamemode-manager # GUI Gamemode Monitoring and Management/Toggling Utility
    nero-umu # UmU Launcher for Windows Games and WINE
    vkd3d-proton
    mangohud # Overlay for Game Performance Monitoring
    mangojuice
    protonup-ng # Manage Proton Versions
    protonup-qt # Manage Proton Versions
    (pkgs.callPackage "${inputs.jonabron}/nix/packages/arrowvortex/default.nix" { }) # StepMania, osu!, and related Chart Editor
    (pkgs.callPackage "${inputs.jonabron}/nix/packages/notitg/default.nix" { }) # NotITG, StepMania-Based Rhythm Game
    inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-stable # osu!stable Windows Build for NixOS Linux
    outfox # StepMania-Based 4K Rhythm Game
    ace-of-penguins # Small Game Suite
    unnamed-sdvx-clone # Sound Voltex Clone/Inspired Game
    kdePackages.kpat # KDE's Solitaire Game Collection
    prismlauncher # Feature-Rich Minecraft Launcher and Mod Manager
    itgmania # StepMania-Based 4K Rhythm Game
    etterna # StepMania-Based 4K Rhythm Game
    phira
    inputs.jonabron.packages.x86_64-linux.gobm # osu!beatmap Downloader
    lutris # Gaming Launcher and WinePrefix Manager
    bottles # Run Windows Applications on Linux
  ];
  bundleArchivers = with pkgs; [
    zip
    p7zip # Extract 7z Archives
    unzip # Extract ZIP Archives
    unrar # Extract RAR Archives
    ntfs3g # Windows NTFS Filesystem Support Utility
    hfsprogs
    cryptsetup # LUKS Disk Encryption Setup Utility
    testdisk
    encfs
    xarchiver
    file-roller
  ];
  bundleVideoProduction = with pkgs; [
    (pkgs.wrapOBS { # OBS Studio with Various Plugins
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        input-overlay
        obs-command-source
        obs-retro-effects
      ];
    })
    kdePackages.kdenlive # Video Editing Software Suite
    kdePackages.ffmpegthumbs
    simplescreenrecorder
    gpu-screen-recorder # Record your Screen through your GPU
    gpu-screen-recorder-gtk # GUI Interface for gpu-screen-recorder
  ];
  bundleTextEditors = with pkgs; [
    anvil-editor # Text Editor inspired by Plan9's ACME
    gnome-text-editor # Simple GNOME Text Editor
    kdePackages.kate # Extensible Text and Code Editor
    marksman
    obsidian # Note Taking Application
  ];
  bundleWeb = with pkgs; [
    httrack # Recursive Website Downloader
    suckit
    wayback_machine_downloader
    wget2
    pastebinit # Interactive CLI Pastebin Posting Utility
  ];
  bundleImageViewers = with pkgs; [
    feh # Minimalist Image Viewer and Wallpaper Setter
    xfce.tumbler
    nsxiv # Suckless Image Viewer
    viewnior # Image Viewer
  ];
  bundleWallpaperManagers = with pkgs; [
    variety
    waypaper # Xorg and Wayland Wallpaper Management Utility
    linux-wallpaperengine # WallpaperEngine for Linux
    yad
  ];
  bundleExplorers = with pkgs; [
    xfce.thunar # XFCE's File Explorer
    yazi
  ];
  bundleNode = with pkgs; [
    nodejs_24 # NodeJS Javascript Development Framework
  ];
  bundleShells = with pkgs; [
    powershell # Microsoft's Powershell
    xonsh # Python-Based Xonsh Shell
    nushell # Nushell
    rc-9front # 9front's rc Shell
    cat9 # LASH Shell for Arcan
    cat9-wrapped # LASH Shell for Arcan
  ];
  bundleXorg = with pkgs; [
    yad
    xmonadctl
    fastcompmgr
    xorg.xeyes # GUI Googly-Eyes following the Cursor for Xorg
    xnotify
    pmenu
    dockapps.wmsystemtray
    dockapps.wmcube
    dockapps.AlsaMixer-app
    dockapps.wmCalClock
    xcolor # Xorg Color-Picker
    nvidia-system-monitor-qt
    xclicker # Xorg Auto-Clicker
    xclip # Xorg Clipboard Utility
    xdotool
    wmctrl
    xorg.xkbutils
    xorg.xkbprint
    xorg.xrandr
    xorg.xprop
    xorg.xwininfo
    lxrandr
    xev
    xorg.xkill
    xdo
    lxappearance # Graphical GTK Theme Changer
    xmobar # XMonad's Default Bar/Dock Application
    glycin-loaders
    xzoom
    xmagnify
    ulauncher # Extensible Application Launcher
  ];
  bundleGeneralUtilities = with pkgs; [
    progress
    outguess
    openssl
    parted # Disk Partitioning Utility
    gparted # Disk Partitioning Utility
    rsync
    inxi
    bc
    usbutils
    zenity
    websocat
    ghostscript
    eza
    bat
    zoxide
    bottom
    bandwhich
    ripgrep # Modern Alternative to Grep
    ripgrep-all # ^ ^ ^
    clock-rs # Rust Clock
    ffmpeg-full
    coreutils-full
    pciutils
    fd
    imv
    jq
    nix-search-cli
    nix-search
    nixd
    manix
    devour # Swallow Windows and Commands under Xorg
    systemdgenie
    killall
    ghidra-bin # Binary Decompilation Utility
    ida-free
    lurk
  ];
  bundleNetworking = with pkgs; [
    # Various Networking Related Utilities
    dhcpcd
    networkmanagerapplet
    networkmanager_dmenu
    wpa_supplicant
    protonvpn-gui
    riseup-vpn
    wireshark
    net-tools
  ];
  bundleNeu = with inputs.neu-nix.packages.x86_64-linux; [
    # Various Wayland.FYI related Tools and Window-Managers
    neuwld
    neuswc
    neumenu
    hevel
    (pkgs.callPackage "${inputs.neu-nix}/packages/hack/default.nix" {
      plan9port-wayland = pkgs.unstable.plan9port-wayland;
      neuwld = inputs.neu-nix.packages.x86_64-linux.neuwld;
    })
    swclock
    swall
    swiv
    mojito
    hst
    tohu
  ];
  bundleThemes = with pkgs; [
    # Various GTK Themes
    inputs.jonabron.packages.x86_64-linux.windows-xp-theme
    inputs.jonabron.packages.x86_64-linux.windows-vista-theme
    inputs.jonabron.packages.x86_64-linux.revista
    inputs.jonabron.packages.x86_64-linux.xptheme
    inputs.jonabron.packages.x86_64-linux.winxp-icons
    inputs.jonabron.packages.x86_64-linux.diinki-aero
    whitesur-gtk-theme
    whitesur-icon-theme
    chicago95
    windows10-icons
  ];
  bundleKeyboard = with pkgs; [
    keyboard-layout-editor
    kalamine
    inputs.jonabron.packages.x86_64-linux.ratctl # Mad Catz Mice Control Utility
    xorg.xkbcomp
    xmodmap # Rebind Keys uder Xorg
    xbindkeys # Rebind Keys under Xorg
    wootility # Wooting Keyboard Utility
    piper # Gaming Mouse Configuration Utility
  ];
in
{
  users.users.puppy = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "puppy";
    extraGroups = [
      "gamemode"
      "usbmux"
      "networkmanager"
      "wheel"
      "dialout"
      "plugdev"
      "guixbuild"
      "libvirtd"
      "input"
      "audio"
      "realtime"
      "ydotool"
      "render"
      "input-remapper"
      "docker"
      "podman"
    ];
    packages =
      with pkgs;
      [
        kitty
        inputs.jonabron.packages.x86_64-linux.image-text-extractor
        inputs.jonabron.packages.x86_64-linux.keyboard-layout-exporter
        inputs.jonabron.packages.x86_64-linux.jonabar
        inputs.nix-init.packages.x86_64-linux.default
        inputs.jonabron.packages.x86_64-linux.momoisay
        espeak
        inputs.jonabron.packages.x86_64-linux.urbit
        kdePackages.karousel
        plasmusic-toolbar
        libsForQt5.qtstyleplugin-kvantum
        libsForQt5.qt5ct
        qemu
        quickemu
        kjv
        emote
        veracrypt
        flameshot
        tesseract
        textsnatcher
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
        pokeget-rs
        unstable.plan9port-wayland
      ]
      ++ bundleBrowsers # Web Browsers
      ++ bundleRust # Rust Development Bundle
      ++ bundleWayland # Wayland Related Bundle
      ++ bundleFetchers # Various System-Fetcher Utilities
      ++ bundleVSTs # Music Production Plugin/VST Bundle
      ++ bundleDAWs # Music Production Bundle
      ++ bundleAudioUtilities # Utilities for Audio and Related
      ++ bundleMessaging # Instant Messaging Bundle
      ++ bundleEmulators # Emulators
      ++ bundleGraphicsDesign # Bundle for Graphic Design and Image Editing
      ++ bundleMusicPlayers # Music Players
      ++ bundleWineAndGames # Bundle for Wine and Windows-/Gaming-Related Software
      ++ bundleArchivers # Various Archiving Tools
      ++ bundleVideoProduction # Bundle for Video Production
      ++ bundleGeneralUtilities # Generally Useful and Recommended System Utilities
      ++ bundleNetworking # Networking Related Bundle
      ++ bundleImageViewers # Image Viewer Bundle
      ++ bundleKeyboard # Keyboard Related Utilities and Software
      ++ bundleThemes # Various GTK Themes
      ++ bundleShells # Various Shells
      ++ bundleNode # NodeJS Development Bundle
      ++ bundleVirtualization # Virtualization Bundle
      ++ bundleHaskell # Haskell Development Bundle
      ++ bundleXorg # Xorg Related Software
      ++ bundleWallpaperManagers # Wallpaper Management
      ++ bundleWeb # Web Related Software and Utilities
      ++ bundleAI # AI/LLM Related Bundle
      ++ bundleFlatpak # Flatpak Utilities
      ++ bundleNeu # Wayland.FYI Stuff
      ++ bundleApple # Utilities Related to Apple iPhones
      ++ bundleTextEditors # Text Editors
      ++ bundleExplorers;
  };
}
