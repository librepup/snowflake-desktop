#!/usr/bin/env bash

cd /etc/nixos
git add *
git add ./*

nix-store --verify --check-contents --repair

doas nixos-rebuild boot \
     --fallback \
     --option substituters \
     "https://grokchan:D7Cpmk3s2b8KJHnbCnE86TwYs8BdEoM5@nix-cache.int.proot.pl https://cache.nixos.org https://nix-community.cachix.org https://nix-gaming.cachix.org https://attic.xuyh0120.win/lantian https://cache.xinux.uz" \
     --option trusted-public-keys \
     "nix-cache.int.proot.pl:QDs0QI0AEilHOfiuFhpg+vX3fbFjdtYFDCmntHR0h04= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4= lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc= cache.xinux.uz:BXCrtqejFjWzWEB9YuGB7X2MV4ttBur1N8BkwQRdH+0=
" \
     --option connect-timeout 30 \
     --option min-free  $((5  * 1024 * 1024 * 1024)) \
     --option max-free  $((10 * 1024 * 1024 * 1024)) \
     --option keep-going true \
     --flake /etc/nixos#snowflake
