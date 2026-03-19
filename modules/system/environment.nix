{ config, pkgs, lib, inputs, ... }:
{
  environment = {
    variables = {
      EDITOR = "nixmacs";
      VISUAL = "nixmacs";
      PAGER = "less";
      TERMINAL = "kitty";
      HISTSIZE = 5000;
      HISTFILESIZE = 10000;
      HISTCONTROL = "ignoredups:erasedups";
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
