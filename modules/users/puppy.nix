{
  config,
  pkgs,
  inputs,
  ...
}:
let
  # Wrapped Python with Packages
  # pythonAIWrapper = pkgs.python313.withPackages (ps: with ps; [
  #   torchWithCuda
  #   torchvision-bin
  #   torchaudio-bin
  #   diffusers
  #   transformers
  #   accelerate
  #   paramiko
  #   psutil
  #   utils
  #   sshtunnel
  #   requests
  #   urllib3
  #   json5
  #   standard-telnetlib
  #   pipx
  #   libusb1
  #   plyvel
  # ]);
  pythonWrapped = pkgs.python313.withPackages (ps: with ps; [
    # LLM/AI
    diffusers
    transformers
    accelerate
    # Discord
    discordpy
    # General
    paramiko
    psutil
    utils
    sshtunnel
    requests
    urllib3
    json5
    standard-telnetlib
    # GUI
    pyqt5
    pyqt6
    pyside6
    setuptools
    tkinter
    multidict
    pyttsx3
    pygobject3
    # PIP
    pipx
    libusb1
    plyvel
    # howdoi
  ]);
  pythonPath = "${pythonWrapped}/${pythonWrapped.sitePackages}";
  pythonPathFile = pkgs.writeText "pythonPathDefinition" pythonPath;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system}; # Define Spicetify-Nix Packages
  torMicrosoftEdgeWrapped = pkgs.writeShellScriptBin "tor-microsoft-edge" ''
    doas ip netns exec tor-net \
      microsoft-edge \
        --proxy-server="socks5://127.0.0.1:9050" \
        --host-resolver-rules="MAP * ~NOTFOUND , EXCLUDE localhost" \
        --proxy-bypass-list="localhost;127.0.0.1" \
        "$@"
  '';
  fehViewerWrapped = pkgs.writeShellScriptBin "fehWrapped" ''
    exec ${pkgs.feh}/bin/feh --geometry --ignore-aspect --recursive --auto-zoom --zoom max --no-menus --draw-filename --zoom-step 10 --scale-down --slideshow-delay '-1' --image-bg '#000000' --auto-reload "$@"
  '';
  personalOllamaNotes = pkgs.writeTextDir "share/ollama-notes.md" ''
    # Models
    Top. hf.co/mradermacher/Huihui-NVIDIA-Nemotron-Nano-9B-v2-abliterated-i1-GGUF:Q4_K_M - Uncensored Fast Abliterated Model by NVIDIA
    1. leeplenty/lumimaid-v0.2:12b - Fully Uncensored
    2. qwen2.5-coder:1.5b - Super Fast Small Model
    3. Uncensored Thinking Models
    3.1. hf.co/Lucy-in-the-Sky/NSFW-flash-Q4_K_M-GGUF:Q4_K_M
    3.2. hf.co/Andycurrent/Gemma-3-1B-it-GLM-4.7-Flash-Heretic-Uncensored-Thinking_GGUF:Q4_K_M
    4. Unsorted Uncensored Models
    4.1. gurubot/self-after-dark:3b-q4_K_M
    4.2. MistaaB/SpicyMorph:latest
    5. all-minilm:latest - Converts Prompts to Data-Points

    # Commands
    ## Create Model with Modelfile
    - `ollama create <MYMODEL> -f /path/to/Modelfile`
  '';
  fehViewerWrappedDesktop = pkgs.writeTextDir "share/applications/fehWrapped.desktop" ''
    [Desktop Entry]
    Name=fehWrapped
    Name[en_US]=fehWrapped
    GenericName=Image Viewer
    GenericName[en_US]=Image Viewer
    Comment=Wrapped Image Viewer and Cataloguer
    Exec=${fehViewerWrapped}/bin/fehWrapped %u $@
    Terminal=false
    Type=Application
    Icon=feh
    Categories=Graphics;2DGraphics;Viewer;
    MimeType=image/bmp;image/gif;image/jpeg;image/jpg;image/pjpeg;image/png;image/tiff;image/webp;image/x-bmp;image/x-pcx;image/x-png;image/x-portable-anymap;image/x-portable-bitmap;image/x-portable-graymap;image/x-portable-pixmap;image/x-tga;image/x-xbitmap;image/heic;
    NoDisplay=true
  '';
  bundleBrowsers = with pkgs; [
    # google-chrome # Google's Web-Browser
    # librewolf-bin # LibreWolf Firefox Forked Web-Browser with a Focus on Privacy
    tor-browser # Tor Browser
    lynx # CLI Web-Browser
    links2 # CLI Web-Browser
    w3m-full # CLI Web-Browser
    unstable.microsoft-edge # Microsoft's Edge Web-Browser (Unstable Channel)
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default # Zen Firefox Forked Web Browser
    # floorp-bin # Floorp Firefox Forked Web-Browser
    filezilla # GUI FTP Client
    inputs.helium.packages.x86_64-linux.default # Helium Chromium Based Web Browser
    # inputs.jonabron.packages.x86_64-linux.pybrowse # Python-Based GUI Browser Selector/Opener/Launcher
    # netflix # GUI Wrapper for Netflix based on Chrome
    # vivaldi # Vivaldi Web-Browser
    # vivaldi-ffmpeg-codecs # Vivaldi Web-Browser Codecs
    # nur.repos.bandithedoge.thorium-bin # Throium Web-Browser
    thunderbird-bin # ThunderBird E-Mail Client Suite
    # widevine-cdm # WideVine DRM Support for Netflix and related Services
    brave # Brave Web Browser
  ];
  bundleKDEPlasma = with pkgs.kdePackages; [
    # Packages related to KDE Plasma
    breeze
    breeze-icons
  ];
  bundleGnome = with pkgs; [
    # Applications by, related to, included in, or meant for GNOME
    gnome-tweaks
    gnome-frog
    gnome-builder
    gnome-decoder
    gnome-contacts
    gnome-calendar
    gnome-system-monitor
    pasystray
    gnome-themes-extra
    glib
  ];
  bundleGnomeExtensions = with pkgs.gnomeExtensions; [
    # Extensions for the GNOME Shell
    focus
    auto-move-windows
    moveclock
    hide-activities-button
    paperwm
    user-themes
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
    # Applications for using, connecting to, or related to Apple's iPhones
    libimobiledevice
    ifuse
    gvfs
  ];
  bundleAI = with pkgs; [
    lmstudio
    personalOllamaNotes
    unstable.ollama-vulkan
    unstable.stable-diffusion-cpp-vulkan
    # unstable.whichllm # Find LLMs for your specific Hardware
    unstable.mistral-rs # MistralRS
    unstable.zeroclaw
    # unstable.openshell # Nvidia OpenShell
    inputs.jonabron.packages.x86_64-linux.how2 # AI for your Shell
    unstable.gemini-cli-bin # Google Gemini Agent
    unstable.agent-browser # Agentic Headless Browser
    opencode
    goose-cli
    aichat
    llama-cpp-vulkan # (O)llama.cpp
    # inputs.stability-matrix-nix.packages.x86_64-linux.default
    shell-gpt
    litellm
    # unstable.openclaw
    unstable.mcp-nixos
    unstable.codex
    unstable.grok-cli
  ];
  bundleFlatpak = with pkgs; [
    # Various Flatpak Related Utilities
    warehouse
    bazaar
    flatpak-xdg-utils
    kdePackages.flatpak-kcm
  ];
  bundlePython = [
    # Packages, Dependencies, Libraries, Tools, and more related to Python
    pkgs.libusb1
    pkgs.libglibutil
    pkgs.libsm
    pkgs.libxrender
    pkgs.libxext
    pkgs.libgtop
    pkgs.libgtkflow4
    pkgs.libGL
    pkgs.uv
    pkgs.pyflyby
    pkgs.gtk3
    pkgs.gobject-introspection
    pkgs.sqlitebrowser
    pythonWrapped
  ];
  bundleHaskell = with pkgs; [
    # Haskell Compiler
    (haskellPackages.ghcWithPackages (ps: with ps; [
      # GUIs
      haskell-gi-base
      gi-gtk4
      # Discord
      discord-haskell
      # General
      text
      gloss
      gloss-rendering
      base
      aeson
      bytestring
      data-default
      data-flags
      di
      di-polysemy
      generic-lens
      lens
      polysemy
      polysemy-plugin
      texts
      text-show
      turtle
      dns
      nix-paths
      xmonad
      xmonad-utils
      xmonad-extras
      xmonad-contrib
      X11
      X11-xft
      x11-xim
      x11-xinput
      X11-xshape
      gi-cairo-render
      renderable
      JuicyPixels
      JuicyPixels-extra
    ]))
    stack # Haskell Package/Module Management Utility
    cabal-install # Haskell Cabal Installer
    haskell-ci
    haskell-language-server
    stylish-haskell
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
    picard # Audio File Tag Editor
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
    # helvum
    volctl
    lyrebird
    easyeffects # Effects Suite, Voice Changer, and Audio Enhancement Utility for PipeWire Microphones
  ];
  bundleMessaging = with pkgs; [
    # signal-desktop-bin # Signal Desktop Chatting Client
    telegram-desktop # Telegram Desktop Chatting Client
    ayugram-desktop # Modded Telegram Client with Ghost Mode
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
    android-translation-layer
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
    charm-freeze # Generate Images from Code
    inputs.jonabron.packages.x86_64-linux.image-text-extractor
    timg
    unstable.findimagedupes # CLI Tool to Identify Duplicate/Similar Images
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
    unstable.vintagestory
    clamav # ClamAV AntiVirus Engine
    clamtk # GUI Interface for ClamAV
    the-powder-toy # Open-Source Sandboxing Game
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
    lxqt.lxqt-archiver
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
    litemdview # Suckless Markdown Viewer
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
    fehViewerWrapped # Wrapped Feh Command
    fehViewerWrappedDesktop
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
  bundleSecurity = with pkgs; [
    bleachbit
    macchanger
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
  bundleShellScripting = with pkgs; [
    shellcheck
    shellharden
    shc
    zenity
    patsh
    dialog
  ];
  bundleGeneralUtilities = with pkgs; [
    sherlock
    unstable.nix-du
    intelmetool
    cpu-x
    sysbench
    dmidecode
    progress
    file
    lshw
    outguess
    with-shell
    openssl
    parted # Disk Partitioning Utility
    gparted # Disk Partitioning Utility
    rsync
    inxi
    bc
    usbutils
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
    devour # Swallow Windows and Commands under Xorg
    systemdgenie
    killall
    ghidra-bin # Binary Decompilation Utility
    # ida-free
    lurk
  ];
  bundleNix = with pkgs; [
    nix-search-cli
    unstable.vulnix
    nix-search
    cached-nix-shell
    nixbang
    nixd
    manix
    unstable.nix-your-shell
  ];
  bundlePenTesting = with pkgs; [
    routersploit
    metasploit
  ];
  bundleNetworking = with pkgs; [
    # Various Networking Related Utilities
    inputs.jonabron.packages.x86_64-linux.urbit
    mdns-scanner
    dhcpcd
    unstable.asn
    rofi-network-manager
    wifi-qr
    aircrack-ng
    nmap
    localsend
    anydesk
    tmate
    upterm
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
    # swall
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
  bundleDocuments = with pkgs; [
    masterpdfeditor4
    libreoffice
    zathura
    texliveFull
  ];
  bundleKeyboard = with pkgs; [
    inputs.jonabron.packages.x86_64-linux.keyboard-layout-exporter
    keyboard-layout-editor
    keyd
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
  environment.etc."pythonPathDefinition".source = pythonPathFile;
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
        unstable.ratty
        kitty
        inputs.nix-init.packages.x86_64-linux.default
        inputs.jonabron.packages.x86_64-linux.desktopancs
        inputs.jonabron.packages.x86_64-linux.jonabar
        inputs.jonabron.packages.x86_64-linux.momoisay
        espeak
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
        normcap
        tesseract
        textsnatcher
        redshift
        keepassxc
        nil
        nixfmt
        qbittorrent
        kdePackages.qt5compat
        unstable.yt-dlp
        rofimoji
        rofi
        blahaj
        zenmap
        zerotierone
        translate-shell
        nix-prefetch-scripts
        gnome-shell-extensions
        gnome-font-viewer
        fontforge-gtk
        fontpreview
        arduino-ide
        pokeget-rs
        unstable.plan9port-wayland
      ]
      ++ bundlePython # Python Development Bundle
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
      ++ bundleGnome # GNOME Applications
      ++ bundleGnomeExtensions # GNOME Shell Extensions
      ++ bundleKDEPlasma # KDE Plasma Packages
      ++ bundleNix # Nix(OS) Related Packages
      ++ bundlePenTesting # Pen-Testing Tools
      ++ bundleShellScripting # Tools related to Shell Scripting
      ++ bundleSecurity # Tools for Security
      ++ bundleDocuments # Tools for Editing Documents
      ++ bundleExplorers; # File Explorers and Related
  };
}
