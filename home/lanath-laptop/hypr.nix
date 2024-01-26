''
  # monitor=eDP-1,1920x1080@144,0x0,1
  env = XCURSOR_SIZE,24
  exec-once = swww init; swww img ${./nord-city.jpeg}
  exec-once = wl-paste --watch cliphist store

  input {
      kb_layout = us
      kb_variant =
      kb_model =
      kb_options =
      kb_rules =

      follow_mouse = 1

      touchpad {
          natural_scroll = no
      }

      numlock_by_default = true

      sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
  }

  general {
      gaps_in = 5
      gaps_out = 20
      border_size = 2
      # col.active_border = rgba(81a1c1ee) rgba(8fbcbbee) 45deg
      # col.inactive_border = rgba(4c566aee)

      layout = dwindle
      resize_on_border = yes
  }

  group {
      # col.border_active = rgba(81a1c1ee)
      # col.border_inactive = rgba(4c566aee)
  }

  decoration {
      rounding = 10
      blurls = lockscreen
      drop_shadow = no
      shadow_range = 0
      shadow_render_power = 0
      col.shadow = 0x44000000
      col.shadow_inactive=0x33000000
      blur {
        # enabled = true
        # size = 2
        # passes = 4
        # ignore_opacity = true
        # brightness = 1
      }
  }

  misc {
      mouse_move_enables_dpms = true
      key_press_enables_dpms = true
      disable_hyprland_logo = true
      disable_splash_rendering = true
  }

  animations {
      enabled = yes
      bezier = myBezier,0.05,0.9,0.1,1.0
      bezier = newBezier, 0.68, -0.6, 0.34, 1.4
      bezier = secondBezier, 0.0, -1, 0.1, 2.0
      bezier = overshot, 0.05, 0.9, 0.1, 1.05
      bezier = md3_standard, 0.2, 0, 0, 1
      bezier = md3_decel, 0.05, 0.7, 0.1, 1
      bezier = md3_accel, 0.3, 0, 0.8, 0.15
      bezier = overshot, 0.05, 0.9, 0.1, 1.1
      bezier = crazyshot, 0.1, 1.6, 0.76, 0.92
      bezier = easeInOutQuint, 0.85, 0, 0.15, 1
      bezier = back, 0.68, -0.6, 0.32, 1.6
      bezier = hyprnostretch, 0.05, 0.9, 0.1, 1.0
      bezier = fluent_decel, 0.1, 1, 0, 1
      bezier = borderCurve,  0.51, 0.54, 0.38, 0.41

      animation = windows, 1, 5, crazyshot, slide
      # animation = borderangle, 1, 40, borderCurve, loop
      animation = workspaces, 1, 5, back
  }

  dwindle {
      pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
      preserve_split = yes # you probably want this
  }

  master {
      new_is_master = true
  }

  gestures {
      workspace_swipe = on
      workspace_swipe_fingers = 3;
      workspace_swipe_min_speed_to_force = 30;
  }

  device:epic-mouse-v1 {
      sensitivity = -0.5
  }



  workspace=1, monitor:HDMI-A-1
  workspace=2, monitor:DP-1
  workspace=3, monitor:DP-2




  windowrule = float,^(spotify)$
  windowrule = float,^(nm-connection-editor)$
  windowrule = float,^(pavucontrol)$
  windowrule = dimaround,^(pavucontrol)$
  windowrule = opacity 0.7 0.7,^(pavucontrol)$
  windowrule = opacity 0.9 0.9,^(discord)$

  windowrule=float,title:^(Open File)(.*)$
  windowrule=float,title:^(Select a File)(.*)$
  windowrule=float,title:^(Choose wallpaper)(.*)$
  windowrule=float,title:^(Open Folder)(.*)$
  windowrule=float,title:^(Save As)(.*)$
  windowrule=float,title:^(Library)(.*)$
  windowrule=float,title:^(Home)(.*)$

  windowrulev2 = float,class:^(.*blueman-manager.*)$
  windowrulev2 = dimaround,class:^(.*blueman-manager.*)$
  windowrulev2 = opacity 0.7 0.7,class:^(Wofi|Rofi|rofi)$
  windowrulev2 = float, class:^(.*[W|R|w|r]ofi.*)$
  windowrulev2 = dimaround, class:^(.*[W|R|w|r]ofi.*)$
  windowrulev2 = opacity 0.8 0.8, class:^(kitty)$
  windowrulev2 = center,class:^(discord)$
  windowrulev2 = opacity 0.8 0.8,floating:1
  windowrulev2 = float,class:^(.*orage.*)$
  windowrulev2 = dimaround,class:^(.*orage.*)$
  windowrulev2 = opacity 0.8 0.8, class:^(.*orage.*)$
  windowrulev2 = float,class:^(.*lxqt-openssh-askpass.*)$
  windowrulev2 = dimaround,class:^(.*lxqt-openssh-askpass.*)$
  windowrulev2 = opacity 0.8 0.8, class:^(.*lxqt-openssh-askpass.*)$
  windowrulev2 = float,class:^(.*ssh-askpass-fullscreen.*)$
  windowrulev2 = dimaround,class:^(.*ssh-askpass-fullscreen.*)$
  windowrulev2 = opacity 0.8 0.8, class:^(.*ssh-askpass-fullscreen.*)$


  # layerrules for better blurs
  layerrule = blur, gtk-layer-shell
  layerrule = blur, swaync-control-center
  # layerrule = ignorealpha 0.4, swaync-control-center
  layerrule = blur, rofi
  # layerrule = ignorealpha 0.4, rofi





  # See https://wiki.hyprland.org/Configuring/Keywords/ for more
  $mainMod = SUPER
  $secMod = SUPER_SHIFT

  # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more

  # Windows
  bind = $mainMod, A, killactive,
  bind = $mainMod, F, fullscreen,
  bind = $mainMod, delete, exit,
  bind = $mainMod, V, togglefloating,
  bind = $mainMod, P, pseudo, # dwindle
  bind = $mainMod, J, togglesplit, # dwindle
  bind = $mainMod, g, togglegroup

  # rofi
  bind = $mainMod, Space, exec, rofi -show drun -modi ssh,calc,filebrowser -show-icons
  bind = $mainMod, C, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy,
  bind = $secMod, C, exec, rofi -show calc -modi ssh,calc,filebrowser,
  bind = $mainMod, S, exec, rofi -show ssh -modi ssh,calc,filebrowser,
  bind = $mainMod, backspace, exec, rofi -show p -modi p:"rofi-power-menu",

  # launch app
  bind = $mainMod, Return, exec, kitty
  bind = $mainMod, b, exec, blueman-manager,
  bind = $mainMod, E, exec, thunar ~

  # misc
  bind = $secMod, S, exec, grim -g "$(slurp)" - | wl-copy,
  bind = $mainMod, l, exec, swaylock


  # Move focus with mainMod + arrow keys
  bind = $mainMod, left, movefocus, l
  bind = $mainMod, right, movefocus, r
  bind = $mainMod, up, movefocus, u
  bind = $mainMod, down, movefocus, d

  bind = $mainMod, left, changegroupactive, b
  bind = $mainMod, right, changegroupactive, f

  # Move focus with mainMod + arrow keys
  bind = $secMod, left, movewindow, l
  bind = $secMod, right, movewindow, r
  bind = $secMod, up, movewindow, u
  bind = $secMod, down, movewindow, d

  bind = $mainMod CTRL, left, moveintogroup, l
  bind = $mainMod CTRL, right, moveoutofgroup


  ${builtins.concatStringsSep "\n" (builtins.genList (
    x: let
      ws = let
        c = (x + 1) / 10;
      in
        builtins.toString (x + 1 - (c * 10));
      in ''
        bind = $mainMod, ${ws}, workspace, ${toString (x + 1)}
        bind = $mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
      ''
      )
    10
  )}

  # Scroll through existing workspaces with mainMod + scroll
  bind = $mainMod, mouse_down, workspace, e+1
  bind = $mainMod, mouse_up, workspace, e-1

  bind = ALT, Tab, cyclenext
  bind = ALT, Tab, bringactivetotop,

  # Move/resize windows with mainMod + LMB/RMB and dragging
  bindm = $mainMod, mouse:272, movewindow
  bindm = $mainMod, mouse:273, resizewindow

  exec-once = nm-applet --indicator
''
