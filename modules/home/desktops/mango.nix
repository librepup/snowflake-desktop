{ config, pkgs, lib, inputs, unstable, ... }:
{
  wayland.windowManager.mango = {
    enable = true;
    settings = ''
      # Autostart
      exec-once=wl-paste --watch cliphist store
      exec-once=dex --autostart --environment mango
      exec-once=waypaper --restore --backend swaybg
      exec-once=xwayland-satellite
      exec-once=swayidle -w timeout 300 'dms ipc call lock lock'
      exec-once=wlr-randr --output DP-1 --mode 1920x1080@143.981003 --output HDMI-A-1 --mode 1920x1080 --scale 1.0 --right-of DP-1
      exec-once=keepassxc
      exec-once=easyeffects --load-preset Jag --hide-window
      exec-once=nixmacs --fg-daemon
      exec-once=pkill -9 -f gnome-keyring-daemon
      exec-once=dbus-update-activation-environment --systemd --all
      exec-once=QT_QPA_PLATFORM=wayland dms run
      exec-once=vicinae server

      # XWayland
      xwayland_persistence = 1
      syncobj_enable = 1
      allow_lock_transparent = 1
      monitorrule=name:HDMI-A-1,width:1920,height:1080,refresh:60
      monitorrule=name:DP-1,width:1920,height:1080,refresh:143.981003,x:1920,y:0

      # Environment
      env = GBM_BACKEND,nvidia-drm
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      env = DISPLAY,:0
      env = XDG_CURRENT_DESKTOP,mango
      env = XDG_SESSION_TYPE,wayland
      env = QT_QPA_PLATFORM,wayland
      env = QT_QPA_PLATFORMTHEME,qt5ct
      env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
      env = MOZ_ENABLE_WAYLAND,1
      env = NIXOS_OZONE_WL,1
      env = ELECTRON_OZONE_PLATFORM_HINT,wayland
      env = OZONE_PLATFORM,wayland
      env = GDK_BACKEND,wayland
      env = WINDOW_MANAGER,mango
      env = SDL_VIDEODRIVER,wayland

      # Input
      xkb_rules_layout = us(altgr-intl)
      xkb_rules_variant = colemak
      xkb_rules_options = caps:ctrl_modifier,ctrl:swapcaps
      repeat_rate = 25
      repeat_delay = 600
      numlockon = 1

      # Window effect
      blur = 1
      blur_layer = 0
      blur_optimized = 1
      blur_params_num_passes = 2
      blur_params_radius = 5
      blur_params_noise = 0.02
      blur_params_brightness = 0.9
      blur_params_contrast = 0.9
      blur_params_saturation = 1.2

      shadows = 1
      layer_shadows = 0
      shadow_only_floating = 1
      shadows_size = 10
      shadows_blur = 15
      shadows_position_x = 0
      shadows_position_y = 0
      shadowscolor = 0x000000ff

      border_radius = 6
      no_radius_when_single = 0
      focused_opacity = 1.0
      unfocused_opacity = 0.8

      # Animation Configuration(support type:zoom,slide)
      # tag_animation_direction: 1-horizontal,0-vertical
      animations = 1
      layer_animations = 1
      animation_type_open = slide
      animation_type_close = zoom
      #animation_type_close = slide
      animation_fade_in = 1
      animation_fade_out = 1
      tag_animation_direction = 1
      zoom_initial_ratio = 0.3
      zoom_end_ratio = 0.1
      #zoom_end_ratio = 0.8
      fadein_begin_opacity = 0.5
      fadeout_begin_opacity = 0.8
      animation_duration_move = 500
      animation_duration_open = 400
      animation_duration_tag = 350
      animation_duration_close = 250
      #animation_duration_close = 800
      animation_duration_focus = 0
      animation_curve_open = 0.46,1.0,0.29,1
      animation_curve_move = 0.46,1.0,0.29,1
      animation_curve_tag = 0.46,1.0,0.29,1
      animation_curve_close = 0.08,0.92,0,1
      animation_curve_focus = 0.46,1.0,0.29,1
      animation_curve_opafadeout = 0.5,0.5,0.5,0.5
      animation_curve_opafadein = 0.46,1.0,0.29,1

      # Scroller Layout Setting
      scroller_structs = 20
      scroller_default_proportion = 1.0
      scroller_focus_center = 0
      scroller_prefer_center = 0
      edge_scroller_pointer_focus = 1
      scroller_default_proportion_single = 1.0
      scroller_proportion_preset = 0.5,0.8,1.0

      # Master-Stack Layout Setting
      new_is_master = 1
      default_mfact = 0.55
      default_nmaster = 1
      smartgaps = 0

      # Overview Setting
      hotarea_size = 10
      enable_hotarea = 1
      ov_tab_mode = 0
      overviewgappi = 5
      overviewgappo = 30

      # Misc
      no_border_when_single = 0
      axis_bind_apply_timeout = 100
      focus_on_activate = 1
      idleinhibit_ignore_visible = 0
      sloppyfocus = 1
      warpcursor = 1
      focus_cross_monitor = 0
      focus_cross_tag = 0
      enable_floating_snap = 0
      snap_distance = 30
      cursor_size = 24
      drag_tile_to_tile = 1

      # Trackpad
      # need relogin to make it apply
      disable_trackpad = 0
      tap_to_click = 1
      tap_and_drag = 1
      drag_lock = 1
      trackpad_natural_scrolling = 1
      disable_while_typing = 1
      left_handed = 0
      middle_button_emulation = 0
      swipe_min_threshold = 1

      # mouse
      # need relogin to make it apply
      mouse_natural_scrolling = 0
      sloppyfocus = 1

      # Appearance
      gappih = 5
      gappiv = 5
      gappoh = 10
      gappov = 10
      scratchpad_width_ratio = 0.8
      scratchpad_height_ratio = 0.9
      borderpx = 4
      rootcolor = 0x1d1f21ff
      bordercolor = 0x1d1f21ff
      focuscolor = 0xEDB6DBff
      maximizescreencolor = 0xEDB6DBff
      urgentcolor = 0xad401fff
      scratchpadcolor = 0x516c93ff
      globalcolor = 0xb153a7ff
      overlaycolor = 0x14a57cff

      # layout support:
      # tile,scroller,grid,deck,monocle,center_tile,vertical_tile,vertical_scroller
      tagrule=id:1,layout_name:scroller
      tagrule=id:2,layout_name:scroller
      tagrule=id:3,layout_name:scroller
      tagrule=id:4,layout_name:tile
      tagrule=id:5,layout_name:monocle
      tagrule=id:6,layout_name:deck
      tagrule=id:7,layout_name:grid
      tagrule=id:8,layout_name:center_tile
      tagrule=id:9,layout_name:vertical_tile

      # reload config
      bind = ALT+SHIFT,p,reload_config

      # menu and terminal
      bind = ALT,t,spawn,vicinae toggle
      bind = ALT+SHIFT,Return,spawn,kitty

      # exit
      #bind=ALT+SHIFT,x,quit
      bind = ALT+SHIFT,x,spawn,~/.scripts/mango-exit.sh
      bind = ALT+SHIFT,q,killclient

      # WinBinds
      bind = SUPER,1,~/.scripts/disableWaylandScreensaver.sh
      bind = SUPER,2,~/.scripts/enableWaylandScreensaver.sh

      # switch window focus
      bind = ALT,Left,focusdir,left
      bind = ALT,Right,focusdir,right
      bind = ALT,Up,focusdir,up
      bind = ALT,Down,focusdir,down

      # swap window
      bind = ALT+SHIFT,Up,exchange_client,up
      bind = ALT+SHIFT,Down,exchange_client,down
      bind = ALT+SHIFT,Left,exchange_client,left
      bind = ALT+SHIFT,Right,exchange_client,right

      # stacker
      bind=ALT,comma,scroller_stack_left
      bind=ALT,period,scroller_stack_right

      # switch window status
      bind = ALT,p,toggleglobal,
      bind = ALT,Tab,toggleoverview,
      bind = ALT+SHIFT,space,togglefloating
      bind = ALT,m,togglemaximizescreen,
      bind = ALT+SHIFT,t,togglefullscreen,
      bind = SUPER+SHIFT,t,togglefakefullscreen,
      bind = SUPER,i,minimized,
      bind = SUPER+SHIFT,I,restore_minimized
      bind = SUPER+CTRL,i,toggle_scratchpad
      bind = SUPER,o,toggleoverlay,

      # scroller layout
      bind = ALT+SHIFT,a,set_proportion,1.0

      # Applications
      bind = ALT+SHIFT,f,spawn,nixmacs-wayland
      bind = ALT+SHIFT,s,spawn,microsoft-edge
      bind = SUPER,e,spawn,thunar
      bind = SUPER,n,spawn,kate
      bind = SUPER,l,spawn,dms ipc call lock lock
      bind = ALT+CTRL,t,spawn,rofi -show drun
      bind = ALT+CTRL+SHIFT,t,spawn,rofi -show run
      bind = ALT,a,spawn,hyprshot -m region --clipboard-only

      # switch layout
      bind = ALT,space,switch_layout

      # tag switch
      bind = SUPER,Left,viewtoleft,0
      bind = CTRL+Super+SHIFT,Left,viewtoleft_have_client,0
      bind = SUPER,Right,viewtoright,0
      bind = CTRL+SUPER+SHIFT,Right,viewtoright_have_client,0
      bind = CTRL+SUPER,Left,tagtoleft,0
      bind = CTRL+SUPER,Right,tagtoright,0

      bind = ALT,1,view,1,0
      bind = ALT,2,view,2,0
      bind = ALT,3,view,3,0
      bind = ALT,4,view,4,0
      bind = ALT,5,view,5,0
      bind = ALT,6,view,6,0
      bind = ALT,7,view,7,0
      bind = ALT,8,view,8,0
      bind = ALT,9,view,9,0

      # tag: move client to the tag and focus it
      # tagsilent: move client to the tag and not focus it
      # bind = ALT,1,tagsilent,1
      bind = ALT+SHIFT,1,tag,1,0
      bind = ALT+SHIFT,2,tag,2,0
      bind = ALT+SHIFT,3,tag,3,0
      bind = ALT+SHIFT,4,tag,4,0
      bind = ALT+SHIFT,5,tag,5,0
      bind = ALT+SHIFT,6,tag,6,0
      bind = ALT+SHIFT,7,tag,7,0
      bind = ALT+SHIFT,8,tag,8,0
      bind = ALT+SHIFT,9,tag,9,0

      # monitor switch
      bind = alt+SHIFT,CTRL,Left,focusmon,left
      bind = alt+SHIFT,CTRL,Right,focusmon,right
      bind = SUPER+ALT,Left,tagmon,left
      bind = SUPER+ALT,Right,tagmon,right

      # gaps
      bind = ALT+SHIFT,X,incgaps,1
      bind = ALT+SHIFT,Z,incgaps,-1
      bind = ALT+SHIFT,G,togglegaps

      # movewin
      bind = CTRL+SHIFT+ALT,Up,movewin,+0,-50
      bind = CTRL+SHIFT+ALT,Down,movewin,+0,+50
      bind = CTRL+SHIFT+ALT,Left,movewin,-50,+0
      bind = CTRL+SHIFT+ALT,Right,movewin,+50,+0

      # resizewin
      bind = CTRL+ALT,Up,resizewin,+0,-50
      bind = CTRL+ALT,Down,resizewin,+0,+50
      bind = CTRL+ALT,Left,resizewin,-50,+0
      bind = CTRL+ALT,Right,resizewin,+50,+0

      bind = CTRL+ALT,h,resizewin,-10,+0 # Left
      bind = CTRL+ALT,j,resizewin,+0,+10 # Down
      bind = CTRL+ALT,k,resizewin,+0,-10 # Up
      bind = CTRL+ALT,l,resizewin,+10,+0 # Right

      bind = ALT,b,spawn,dms ipc call bar toggle index 0
      bind = SUPER,q,spawn,copyq toggle
      bind = ALT,c,spawn,~/.scripts/hyprpickerScript.sh
      bind = SUPER,m,spawn,tauon
      bind = SUPER+SHIFT,g,spawn,goofcord --disable-gpu --enable-features=UseOzonePlatform --ozone-platform=wayland
      bind = SUPER+SHIFT,d,spawn,QT_QPA_PLATFORM=wayland dms run
      bind = SUPER,c,spawn,dms ipc call clipboard open
      bind = SUPER,z,spawn,hyprmagnifier --size 512x512
      bind = SUPER,a,spawn,pavucontrol


      # Mouse Button Bindings
      # NONE mode key only work in ov mode
      mousebind = ALT,btn_left,moveresize,curmove
      mousebind = ALT,btn_right,moveresize,curresize

      # Axis Bindings
      axisbind = SUPER,UP,viewtoleft_have_client
      axisbind = SUPER,DOWN,viewtoright_have_client

      # layer rule
      layerrule = animation_type_open:zoom,layer_name:rofi
      layerrule = animation_type_close:zoom,layer_name:rofi

      # Window Rules
      windowrule = tags:2,monitor:HDMI-A-1,appid:vesktop
      windowrule = tags:2,monitor:HDMI-A-1,appid:goofcord
      windowrule = tags:3,monitor:HDMI-A-1,appid:steam
    '';
    autostart_sh = ''
      # See autostart.sh
      # Note: here no need to add shebang
      wl-paste --watch cliphist store &
      dex --autostart environment mango &
      waypaper --restore --backend swaybg &
      noctalia-shell &
      vicinae server &
    '';
  };
}
