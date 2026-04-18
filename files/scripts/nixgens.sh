#!/usr/bin/env bash
# Nix and Home Generations

nixgens() {
  NixGens=$(doas nix-env --list-generations --profile /nix/var/nix/profiles/system)
  HomeGens=$(home-manager generations)
  echo -e "NixOS Generations:\n$NixGens\nHome-Manager Generations:\n$HomeGens\n"
}
