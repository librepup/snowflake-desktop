{ config, pkgs, inputs, ... }:
{
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
}
