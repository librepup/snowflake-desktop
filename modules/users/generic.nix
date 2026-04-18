{ config, pkgs, lib, inputs, ... }:
{
  users.defaultUserShell = pkgs.zsh;
}
