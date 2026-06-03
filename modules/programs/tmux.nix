{ config, pkgs, inputs, ... }:
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = ''
      # Options
      set -g @tmux-gruvbox 'dark'
      set -g status-left '  %H:%M '
      set -g status-right ' 󰭨 %d.%m.%Y '

      # Prefix
      unbind C-b
      set-option -g prefix C-c
      bind-key C-c send-prefix

      # Windows
      bind v split-window -v
      bind 2 split-window -v
      bind h split-window -h
      bind 3 split-window -h
      bind t new-window
      bind w kill-window

      # Panes
      bind Right select-pane -R
      bind Left select-pane -L
      bind Up select-pane -U
      bind Down select-pane -D
      bind 0 kill-pane

      # Tabs
      bind Tab next
      bind p prev
      bind q kill-session

      # Default Shell
      set-option -g default-shell /run/current-system/sw/bin/zsh
    '';
    plugins = [
      pkgs.tmuxPlugins.gruvbox
    ];
  };
}
