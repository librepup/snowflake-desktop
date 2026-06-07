# Theme Options and Related
## Colorschemes, Themes, and Icons
### Themes
#### Diinki Aero
1. Theme: `lib.mkForce "Diinki Aero";`
2. Package: `inputs.jonabron.packages.x86_64-linux.diinki-aero;`
#### Windows XP Luna
1. Theme: `lib.mkForce "Windows XP Luna";`
2. Package: `inputs.jonabron.packages.x86_64-linux.xptheme;`
#### Chicago95
1. Theme: `lib.mkForce "Chicago95";`
2. Package: `pkgs.chicago95;`
#### WhiteSur
1. Theme: `lib.mkForce "WhiteSur-Dark";`
2. Package: `lib.mkForce pkgs.whitesur-gtk-theme;`

### Icons
#### ReVista
1. Theme: `lib.mkForce "ReVista";`
2. Package: `lib.mkForce inputs.jonabron.packages.x86_64-linux.revista;`
#### Chicago95
1. Theme: `lib.mkForce "Chicago95";`
2. Package: `lib.mkForce pkgs.chicago95;`
#### WhiteSur
1. Theme: `lib.mkForce "WhiteSur-dark";`
2. Package: `lib.mkForce pkgs.whitesur-icon-theme;`

### Cursors
#### XCursor Pro Red
1. Theme: `"XCursor-Pro-Red";`
2. Package: `pkgs.xcursor-pro;`
3. Size: `size = 28;`

## Extras
### Force Dark Theme
```nix
gtk = {
  enable = true;
  colorScheme = lib.mkForce "dark";
};
```

### GTK4
```nix
gtk = {
  gtk4 = {
    enable = true;
    colorScheme = lib.mkForce "dark";
    theme = {
      name = "Colloid-Dark";
      package = lib.mkForce pkgs.colloid-gtk-theme;
    };
  };
};
```
