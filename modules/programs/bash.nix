{ config, lib, pkgs, inputs, ... }:
{
  programs.bash = {
    completion.enable = true;
    enableLsColors = true;
    promptInit = ''
      [[ -v EMACSLOADPATH ]] && unset EMACSLOADPATH
      if alias 9 >/dev/null 2>&1; then
        unalias 9
      fi
      if [[ -n "$IN_NIX_SHELL" ]]; then
        PS1='  (shell) \w '
      elif [[ -n "$GUIX_ENVIRONMENT" ]]; then
        PS1='  (shell) \w '
      else
        PS1='  \w '
      fi
      if [ -d "$HOME/.scripts/shell" ]; then
        for script in "$HOME/.scripts/shell"/*; do
          [ -f "$script" ] && source "$script"
        done
      fi
    '';
    shellInit = ''
      if alias 9 > /dev/null 2>&1; then
        unalias 9
      fi
      if [ -d "$HOME/.shell-autoload-functions" ]; then
        for script in "$HOME/.shell-autoload-functions"/*; do
          [ -f "$script" ] && source "$script"
        done
      fi

      eval "$(zoxide init bash)"
    '';
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
      ec = "emacsclient -c -nw $@";
      vim = "nixmacs -nw $@";
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
      tagmp3 = "$HOME/.scripts/tagmp3.sh $@";
      size = "du -sh $@";
      analogcity = "ssh lowlife@45.79.250.220 $@";
      shreddy = "shred -z -u -v --iterations=1 $@";
      ipinfo = "curl ipinfo.io | jq .";
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
  };
}
