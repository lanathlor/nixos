''

monitor=eDP-1,1920x1080@144,0x0,1
env = XCURSOR_SIZE,24
exec=swww init && swww img ${./nord-city.jpeg}

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

    sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
}

general {
    gaps_in = 5
    gaps_out = 20
    border_size = 2
    col.active_border = rgba(81a1c1ee) rgba(8fbcbbee) 45deg
    col.inactive_border = rgba(4c566aee)
    col.group_border = rgba(4c566aee)
    col.group_border_active = rgba(81a1c1ee)

    layout = dwindle
    resize_on_border = yes
}

decoration {
    rounding = 10
    blurls = lockscreen
    drop_shadow = no
    shadow_range = 125
    shadow_render_power = 4
    col.shadow = 0x44000000
    col.shadow_inactive=0x33000000
    blur = yes
    blur_size = 4
    blur_passes = 4
    blur_new_optimizations = on
    blur_ignore_opacity = true
    # blur_brightness = 1.1
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
    bezier = hyprnostretch, 0.05, 0.9, 0.1, 1.0
    bezier = fluent_decel, 0.1, 1, 0, 1
    bezier = borderCurve,  0.51, 0.54, 0.38, 0.41

    animation = windows, 1, 8, crazyshot, slide
    # animation = borderangle, 1, 40, borderCurve, loop
    animation = workspaces, 1, 8, crazyshot
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



windowrule = float,^(pavucontrol)$
windowrule = dimaround,^(pavucontrol)$
windowrule = float,^(spotify)$
windowrule = float,^(nm-connection-editor)$
windowrule = dimaround,^(pavucontrol)$
windowrule = float,^(eog)$
windowrule = float,^(org.gnome.Calculator)$
windowrule = float,^(org.gnome.Nautilus)$
windowrule = float,^(org.gnome.clocks)$
windowrule = float,^(discord)$
windowrule = float,^(virtualbox)$

# I dont know whether these are supposed to help or not
windowrule=float,title:^(Open File)(.*)$
windowrule=float,title:^(Select a File)(.*)$
windowrule=float,title:^(Choose wallpaper)(.*)$
windowrule=float,title:^(Open Folder)(.*)$
windowrule=float,title:^(Save As)(.*)$
windowrule=float,title:^(Library)(.*)$
windowrule=float,title:^(Home)(.*)$

# Opacity Rules
windowrulev2 = float,class:^(.*blueman-manager.*)$
windowrulev2 = dimaround,class:^(.*blueman-manager.*)$
windowrulev2 = opacity 0.7 0.7,class:^(Wofi|Rofi)$
windowrulev2 = float, class:^(.*[W|R|w|r]ofi.*)$
windowrulev2 = dimaround, class:^(.*[W|R|w|r]ofi.*)$
windowrulev2 = opacity 0.8 0.8, class:^(kitty)$
windowrulev2 = center,class:^(discord)$
windowrulev2 = center,class:^(org.gnome.Nautilus)$
windowrulev2 = center,class:^(org.gnome.Calculator)$

# layerrules for better blurs
layerrule = blur, gtk-layer-shell
layerrule = blur, swaync-control-center
# layerrule = ignorealpha 0.4, swaync-control-center
layerrule = blur, waybar
# layerrule = ignorealpha 0.4, waybar
layerrule = blur, rofi
# layerrule = ignorealpha 0.4, rofi
layerrule = blur, swaync-notification-window
# layerrule = ignorealpha 0.4, swaync-notification-window





# See https://wiki.hyprland.org/Configuring/Keywords/ for more
$mainMod = SUPER
$secMod = SUPER_SHIFT

# Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
bind = $mainMod, Return, exec, kitty
bind = $mainMod, A, killactive,
bind = $mainMod, F, fullscreen,
bind = $mainMod, M, exit,
bind = $mainMod, Space, exec, rofi -show drun -modi ssh,calc,filebrowser -show-icons
bind = $mainMod, E, exec, rofi -show filebrowser -modi ssh,calc,filebrowser
bind = $mainMod, C, exec, rofi -show calc -modi ssh,calc,filebrowser,
bind = $mainMod, S, exec, rofi -show ssh -modi ssh,calc,filebrowser,
bind = $mainMod, b, exec, blueman-manager,
bind = $mainMod, V, togglefloating,
bind = $mainMod, P, pseudo, # dwindle
bind = $mainMod, J, togglesplit, # dwindle
bind = $mainMod, g, togglegroup
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

exec-once = waybar
exec-once = nm-applet --indicator
''
