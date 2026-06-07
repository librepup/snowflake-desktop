# Xorg
## Desktop Environments
1. GNOME
2. KDE Plasma 6

## Display Managers
1. SDDM

## Window Managers
1. XMonad (Default Session: `"none+xmonad"`)
2. hevel
3. tohu
4. WindowMaker
5. AwesomeWM
6. i3 (Gaps, Rounded)
7. Niri (Default Session: `"niri"`)

### XMonad
#### Extra Packages
```nix
extraPackages = hpkgs: [
  hpkgs.X11
  hpkgs.X11-xshape
  hpkgs.xmonad-contrib
  hpkgs.xmonad-extras
];
```

### AwesomeWM
#### Extra Lua Modules
```nix
luaModules = with pkgs.luaPackages; [
  luarocks
  luadbi-mysql
  awesome-wm-widgets
];
```

### i3
#### Extra Packages
```nix
extraPackages = with pkgs; [
  dmenu
  i3status
  i3blocks
  autotiling
  polybarFull
  picom
  betterlockscreen
  dunst
  libnotify
  eww
];
```

### Hevel
1. Package: `inputs.neu-nix.packages.x86_64-linux.hevel`
#### Session
```nix
hevelSession = (pkgs.writeTextDir "share/wayland-sessions/hevel.desktop" ''
  [Desktop Entry]
  Name=hevel
  Comment=Custom Hevel WM Session
  Exec=${neuswcPkg}/bin/swc-launch ${hevelPkg}/bin/hevel
  Type=Application
'').overrideAttrs (oldAttrs: {
  passthru.providedSessions = [ "hevel" ];
});
```

### Tohu
1. Package: `inputs.neu-nix.packages.x86_64-linux.tohu`
#### Session
```nix
tohuSession = (pkgs.writeTextDir "share/wayland-sessions/tohu.desktop" ''
  [Desktop Entry]
  Name=tohu
  Comment=Custom Tohu WM Session
  Exec=${neuswcPkg}/bin/swc-launch ${tohuPkg}/bin/tohu
  Type=Application
'').overrideAttrs (oldAttrs: {
  passthru.providedSessions = [ "tohu" ];
});
```
