{ config, pkgs, lib, inputs, ... }:
{
  # services.envfs.enable = true;
  console.keyMap = "colemak";
  environment = {
    variables = {
      NIXPKGS_ALLOW_WARN = 1;
      EDITOR = "nixmacs";
      VISUAL = "nixmacs";
      PAGER = "less";
      TERMINAL = "kitty";
      HISTSIZE = 5000;
      HISTFILESIZE = 10000;
      HISTCONTROL = "ignoredups:erasedups";
      XKB_DEFAULT_LAYOUT = "us";
      XKB_DEFAULT_VARIANT = "colemak";
    };
    interactiveShellInit = ''
      unset EMACSLOADPATH
    '';
    extraInit = ''
      unset EMACSLOADPATH
      if [ "$USER" = "root" ]; then
        export PATH=/root/.nix-profile/bin:$PATH
      fi
    '';
  };
}
