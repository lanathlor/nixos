''
monitor=eDP-1,1920x1080@144,0x0,1
env = XCURSOR_SIZE,24

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
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

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
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    rounding = 10

    inactive_opacity = 0.9

    blur = yes
    blur_size = 3
    blur_passes = 1
    blur_new_optimizations = on

    drop_shadow = yes
    shadow_range = 4
    col.shadow = rgba(4c566aee)
    col.shadow_inactive = rgba(81a1c1ee)
}

animations {
    enabled = yes

    # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

    bezier = myBezier, 0.05, 0.9, 0.1, 1.05

    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

dwindle {
    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = yes # you probably want this
}

master {
    # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    new_is_master = true
}

gestures {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    workspace_swipe = off
}

# Example per-device config
# See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
device:epic-mouse-v1 {
    sensitivity = -0.5
}

# Example windowrule v1
# windowrule = float, ^(kitty)$
# Example windowrule v2
# windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
# See https://wiki.hyprland.org/Configuring/Window-Rules/ for more


# See https://wiki.hyprland.org/Configuring/Keywords/ for more
$mainMod = SUPER
$secMod = SUPER_SHIFT

# Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
bind = $mainMod, Return, exec, kitty
bind = $mainMod, A, killactive,
bind = $mainMod, F, fullscreen,
bind = $mainMod, M, exit,
bind = $mainMod, E, exec, dolphin
bind = $mainMod, V, togglefloating,
bind = $mainMod, Space, exec, wofi --show drun
bind = $mainMod, P, pseudo, # dwindle
bind = $mainMod, J, togglesplit, # dwindle
bind = $mainMod, e, togglegroup

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

# Move/resize windows with mainMod + LMB/RMB and dragging
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow

exec-once = waybar
exec=swww init && swww img dotfiles/nord1.png
''
