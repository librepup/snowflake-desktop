[6~]{ config, pkgs, inputs, ... }:
{
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
        tree = "eza --icons -T -L=1000 $@";
        cls = "clear $@";
        # Nix Related
        home-rebuild = "home-manager switch --flake /etc/nixos#puppy $@";
        home-garbage = "home-manager expire-generations '-1 days'";
        # rebuild = "doas nixos-rebuild switch --flake /etc/nixos#snowflake $@";
        garbage = "doas nix-collect-garbage -d $@";
        ns = "nix-shell --run zsh $@";
        nss = "nix-search $@";
        nis = "nix-search --details --max-results 3 --search \"$@\"";
        no = "manix $@";
        nix-options = "manix $@";
        nixbuild = "echo 'Did you mean `buildnix`?'";
        repair = "doas nix-store --verify --repair $@";
        nix-generations = "doas nix-env -p /nix/var/nix/profiles/system --list-generations";
        generations = "echo -e 'NixOS Generations:\n' && doas nix-env --list-generations --profile /nix/var/nix/profiles/system && echo -e '\nHome-Manager Generations:\n' && ls -l ~/.local/state/nix/profiles/ | grep home-manager";
        home-generations = "ls -l ~/.local/state/nix/profiles/ | grep home-manager $@";
        # Fetching
        fetch = "echo -e 'mf => Microfetch\npf => Pridefetch\nhf => Hyfetch\nff => Fastfetch'";
        hf = "hyfetch $@";
        deToSv = "trans de:sv '$@'";
        enToSv = "trans en:sv '$@'";
        svToDe = "trans sv:de '$@'";
        pf = "pridefetch -f trans --width 11 $@";
        svToEn = "trans sv:en '$@'";
        mf = "microfetch $@";
        ff = "fastfetch $@";
        gf = "fastfetch --pipe false --logo Guix | sed 's/NixOS 25.11 (Xantusia)/Guix System/g' $@";
        pef = "pfetch $@";
        of = "onefetch $@";
        distro = "cat /etc/*-release | grep 'PRETTY_NAME' | cut -c 13- | sed 's/\"//g'";
        lsbOsRelease = "lsb_release -sd $@";
        # Editing
        e = "nixmacs -nw $@";
        ec = "nixmacs-client -c -nw $@";
        vim = "nixmacs -nw $@";
        # Extra
        ripgrep = "rg $@";
        oldgrep = "grep $@";
        cargorun = "RUSTFLAGS='-Awarnings' cargo run";
        fireswitch = "nix-shell -p firefox --run 'firefox -no-remote -ProfileManager' $@";
        findstring = "grep -rni \"$@\" *";
        # Zipping
        tarShow = "tar tvf $@";
        tarUnzip = "tar xvf $@";
        tarZip = "echo 'Arg1: Archive.tar.gz, Arg2: Full Path of the Folder';tar -czvf $@";
        zipCreate = "echo 'Arg1: Archive.zip, Arg2: Folder/';zip -r $@";
        # Applications
        compressMp4To10MB = "ffmpeg -i $@ -b:v 1000k -c:a aac -b:a 128k resultingVideoCompressed.mp4";
        gamingmode = "gamemoderun mangohud $@";
        gamingmodeDevour = "devour gamemoderun mangohud $@";
        animescript = "$HOME/.scripts/animescript.sh $@";
        bible = "kjv $@";
        img = "timg ./* --center --title=\"%b\" --grid=4 -p k";
        pic = "timg $@ --center --title=\"%b\" --grid=4 -p k";
        kitten-img = "kitten icat --use-window-size 380,380,380,380 $@";
        explorer = "yazi $@";
        poke = "pokeget --hide-name $@";
        weather = "curl wttr.in/Berlin $@";
        wetter = "curl wttr.in/Berlin $@";
        htop = "btm --theme nord $@";
        i = "viewnior $@";
        v = "mpv $@";
        iftop = "bandwhich $@";
        restartXdgDesktopPortal = "pkill -f xdg-desktop-portal; systemctl --user restart xdg-desktop-portal; systemctl --user restart xdg-desktop-portal-gnome";
        xdg-desktop-portal-restart = "pkill -f xdg-desktop-portal; systemctl --user restart xdg-desktop-portal; systemctl --user restart xdg-desktop-portal-gnome";
        gc = "git clone $@";
        ctluu = "systemctl --user $@";
        ctl = "systemctl $@";
        findDuplicateImages = "findimagedupes -R -- . $@";
        find-duplicate-images = "findimagedupes -R -- . $@";
        picom-no-frame-pacing = "picom --backend glx  --no-frame-pacing $@";
        bat = "bat --style=plain --decorations=always --color=always --theme=base16 --pager=less --paging=auto --wrap=auto $@";
        wp = "feh --bg-fill $@";
        feh = "feh --geometry --ignore-aspect --recursive --auto-zoom --zoom fill --scale-down --slideshow-delay '-1' --font 'SourceCode Pro for Powerline' --image-bg '#000000' --auto-reload $@";
        fpak-run = "flatpak run --share=network --socket=fallback-x11 --socket=x11 --nosocket=wayland $@";
        fpak-install = "flatpak install --user $@";
        forcekill = "kill -9 $@";
        size = "du -sh $@";
        analogcity = "ssh lowlife@45.79.250.220 $@";
        shreddy = "shred -z -u -v --iterations=1 $@";
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
        pqiv = "pqiv --action='toggle_scale_mode(5)' --bind-key='p { goto_file_relative(-1) }' --bind-key='n { goto_file_relative(1) }' --bind-key='r { rotate_right() }' --bind-key='l { toggle_slideshow() }' --slideshow-interval=1 --hide-info-box --background-pattern=black --end-of-files-action=wrap-no-reshuffle $@";
        cleanflatpak = "flatpak uninstall --unused";
        guix-garbage = "guix gc $@";
        nonet = "unshare -n --map-current-user $@";
        guix-update = "guix pull && guix package --upgrade && guix gc $@";
        search = "nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history $@";
        zathura = "devour zathura $@";
        gimp = "devour gimp $@";
        krita = "devour krita $@";
        zen = "devour zen $@";
        firefox = "devour firefox $@";
        floorp = "devour floorp $@";
        nvidia-system-monitor-qt = "qnvsm $@";
        ardour = "devour ardour8 $@";
        ollamaGemma3 = "ollama run gemma3 $@";
        ollamaServe = "ollama serve $@";
        ollamaExtra = "OLLAMA_MODELS=/extra/DotOllamaModels ollama serve";
        ollamaMnt = "OLLAMA_MODELS=/mnt/AI/ollama/models ollama serve";
        haskellCompile = "ghc -o Program Main.hs";
      };
      shellInit = ''
        # Unset Guix Emacs Load-Path and the Default '9' Alias
        unset -m EMACSLOADPATH
        unalias -m 9

        # Enable Auto-Correction/Suggestion
        setopt CORRECT
        SPROMPT='Unknown Command "%F{red}%R%f", did you mean "%F{green}%r%f"? (y/n) '

        # Set Completions Path
        fpath=(~/.shell-autoload-functions/comps $fpath)
        autoload -Uz compinit
        compinit

        autoload -U select-word-style
        select-word-style bash
        bindkey '^W' backward-kill-word

        # Source Auto-Load Functions
        if [ -d "$HOME/.shell-autoload-functions" ]; then
          for script in "$HOME/.shell-autoload-functions/funcs"/*.sh; do
            [ -f "$script" ] && source "$script"
          done
        fi

        # Guix Initialization and Setup
        if [[ "$USER" != "root" ]]; then
          GUIX_PROFILE="$HOME/.config/guix/current"
          . "$GUIX_PROFILE/etc/profile"
          GUIX_PROFILE="$HOME/.guix-profile"
          . "$GUIX_PROFILE/etc/profile"
          GUIX_PROFILE="/var/guix/profiles/per-user/puppy/guix-profile"
          . "$GUIX_PROFILE/etc/profile"
          source "$GUIX_PROFILE/etc/profile"
        fi

        # Nix-Shell Variable
        export NIXPKGS_ALLOW_UNFREE=1
        export NIXPKGS_ALLOW_INSECURE=1

        # Initialize Zoxide (A 'cd' Alternative)
        eval "$(zoxide init zsh)"

        # Rebuild Function that Hides Evaluation Warnings, but keeps Displaying Critical Errors
        rebuildOld() {
          doas nixos-rebuild switch --flake /etc/nixos#snowflake "$@"
        }
        rebuild() {
          doas nixos-rebuild switch --flake /etc/nixos#snowflake "$@" 2> >(grep -vE \
            "^evaluation warning|\
        Please migrate to the new structured attribute set format|\
        See the module documentation for examples|\
        The old string format will be removed|\
        This will soon not be possible" >&2)
        }
        rebuildFirstIteration() {
          doas nixos-rebuild switch --flake /etc/nixos#snowflake "$@" 2> >(grep -v "^evaluation warning" >&2)
        }
        networkStatus() {
          echo -e "\n -> Current Main Route:"
          ip route get 1.1.1.1
          echo -e "\n -> Default IP Route:"
          ip route show default
          echo -e "\n -> NetworkManager Active Devices:"
          nmcli connection show --active
          echo -e "\n -> Network-Capable Devices:"
          ip a | grep -E "UP|MULTICAST" | sed '/LOOPBACK/d' | sed '/virbr/d' | awk '{print $2}' | sed 's/://g'
        }
        tmpmacs() {
          tmux new-session -f /etc/nixos/files/config/tmux/user.conf \
                           -D \
                           -s "Temporary" \
                           'TERM=xterm-old nixmacs-client -c -nw -q --eval "(load-file \"\/etc\/nixos\/files\/scripts\/temporary.el\")"' \
                           "$@"
        }
      '';
      ohMyZsh = {
        enable = true;
        plugins = [
          fzf-zsh-plugin
          zsh-f-sy-h
          zsh-autopair
          zsh-completions
          zsh-autosuggestions
          nix-zsh-completions
        ];
        theme = "";
      };
      promptInit = ''
        unset -m EMACSLOADPATH
        unalias -m 9
        export _prompt_newline=$'\n'
        if [[ "$USER" == "root" ]]; then
          if [[ -n "$IN_NIX_SHELL" ]]; then
            PROMPT="  () (nix-shell) (%~)''${_prompt_newline}-> "
          elif [[ -n "$GUIX_ENVIRONMENT" ]]; then
            PROMPT="  () (guix-shell) (%~)''${_prompt_newline}-> "
          else
            PROMPT='() %~ -> '
          fi
        else
          if [[ -n "$IN_NIX_SHELL" ]]; then
            PROMPT="  (nix-shell) (%~)''${_prompt_newline}-> "
          elif [[ -n "$GUIX_ENVIRONMENT" ]]; then
            PROMPT="  (guix-shell) (%~)''${_prompt_newline}-> "
          else
            PROMPT='(%~) -> '
          fi
        fi
      '';
    };
  };
}
