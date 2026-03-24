{ config, pkgs, inputs, ... }:
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
        rebuild = "doas nixos-rebuild switch --flake /etc/nixos#snowflake $@";
        garbage = "doas nix-collect-garbage -d $@";
        ns = "nix-shell --run zsh $@";
        nss = "nix-search $@";
        no = "manix $@";
        nix-options = "manix $@";
        nixbuild = "echo 'Did you mean `buildnix`?'";
        repair = "doas nix-store --verify --repair $@";
        nix-generations = "doas nix-env --list-generations --profile /nix/var/nix/profiles/system $@";
        generations = "echo -e 'NixOS Generations:\n' && doas nix-env --list-generations --profile /nix/var/nix/profiles/system && echo -e '\nHome-Manager Generations:\n' && ls -l ~/.local/state/nix/profiles/ | grep home-manager";
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
        bible = "kjv $@";
        img = "kitten icat --use-window-size 380,380,380,380 $@";
        explorer = "yazi $@";
        poke = "pokeget --hide-name $@";
        weather = "curl wttr.in/Berlin $@";
        wetter = "curl wttr.in/Berlin $@";
        htop = "btm --theme nord $@";
        iftop = "bandwhich $@";
        gc = "git clone $@";
        ocat = "cat $@";
        cat = "bat --style=plain --decorations=always --color=always --theme=base16 --pager=less --paging=auto --wrap=auto $@";
        wp = "feh --bg-fill $@";
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
        cleanflatpak = "flatpak uninstall --unused";
        guix-garbage = "guix gc $@";
        guix-update = "guix pull && guix package --upgrade && guix gc $@";
        search = "nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history $@";
        zathura = "devour zathura $@";
        gimp = "devour gimp $@";
        krita = "devour krita $@";
        zen = "devour zen $@";
        firefox = "devour firefox $@";
        floorp = "devour floorp $@";
        ardour = "devour ardour8 $@";
      };
      shellInit = ''
        unset -m EMACSLOADPATH
        unalias -m 9

        setopt CORRECT
        SPROMPT='Unknown Command "%F{red}%R%f", did you mean "%F{green}%r%f"? (y/n) '

        if [ -d "$HOME/.shell-autoload-functions" ]; then
          for script in "$HOME/.shell-autoload-functions"/*; do
            [ -f "$script" ] && source "$script"
          done
        fi

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
          nixmacs -nw "$file"
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
        if [[ "$USER" == "root" ]]; then
          if [[ -n "$IN_NIX_SHELL" ]]; then
            PROMPT='  () (shell) %~ '
          elif [[ -n "$GUIX_ENVIRONMENT" ]]; then
            PROMPT='  () (shell) %~ '
          else
            PROMPT='  () %~ '
          fi
        else
          if [[ -n "$IN_NIX_SHELL" ]]; then
            PROMPT='  (shell) %~ '
          elif [[ -n "$GUIX_ENVIRONMENT" ]]; then
            PROMPT='  (shell) %~ '
          else
            PROMPT='  %~ '
          fi
        fi
        if [ -d "$HOME/.scripts/shell" ]; then
          for script in "$HOME/.scripts/shell"/*; do
            [ -f "$script" ] && source "$script"
          done
        fi
      '';
    };
  };
}
