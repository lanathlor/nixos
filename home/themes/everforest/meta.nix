{ pkgs }:
let c = import ./colors.nix; in
{
  name     = "Everforest";
  wallpaper = pkgs.runCommand "everforest-wallpaper.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
    convert -size 1920x1080 gradient:"#2d353b-#3d484d" $out
  '';
  waybarCss = ./waybar/style.css;
  gtkTheme  = "Everforest-Dark-B";
  gtkIcons  = "Papirus-Dark";

  neovimColorscheme = "everforest";
  neovimPlugin      = pkgs.vimPlugins.everforest;

  kittyColors = pkgs.writeText "everforest-kitty-colors" ''
    foreground            #d3c6aa
    background            #2d353b
    selection_foreground  #2d353b
    selection_background  #475258
    url_color             #7fbbb3
    cursor                #d3c6aa
    color0  #2d353b   color8  #475258
    color1  #e67e80   color9  #e67e80
    color2  #a7c080   color10 #a7c080
    color3  #dbbc7f   color11 #dbbc7f
    color4  #7fbbb3   color12 #7fbbb3
    color5  #d699b6   color13 #d699b6
    color6  #83c092   color14 #83c092
    color7  #859289   color15 #d3c6aa
  '';

  tmuxConf = pkgs.writeText "everforest-tmux-colors" ''
    set -g status-style    "bg=#2d353b,fg=#d3c6aa"
    set -g status-interval 2
    set -g status-left        "#[bg=#2d353b,fg=#7fbbb3]#[bg=#7fbbb3,fg=#2d353b,bold] #S #[bg=#2d353b,fg=#7fbbb3] "
    set -g status-left-length 30
    set -g status-right        " #[bg=#2d353b,fg=#7fbbb3]#[bg=#7fbbb3,fg=#2d353b]  %H:%M    %d %b #[bg=#2d353b,fg=#7fbbb3]"
    set -g status-right-length 40
    set -g window-status-style         "bg=#2d353b"
    set -g window-status-current-style "bg=#2d353b"
    set -g window-status-separator     ""
    set -g window-status-format \
      "#[bg=#2d353b,fg=#3d484d]#[bg=#3d484d,fg=#d3c6aa] #I  #W #[bg=#2d353b,fg=#3d484d]"
    set -g window-status-current-format \
      "#[bg=#2d353b,fg=#7fbbb3]#[bg=#7fbbb3,fg=#2d353b,bold] #I  #W #[bg=#2d353b,fg=#7fbbb3]"
    set -g pane-border-style        "fg=#3d484d"
    set -g pane-active-border-style "fg=#7fbbb3"
    set -g message-style            "bg=#3d484d,fg=#d3c6aa"
    set -g message-command-style    "bg=#3d484d,fg=#d3c6aa"
    set -g mode-style               "bg=#7fbbb3,fg=#2d353b"
  '';

  starshipToml = pkgs.writeText "everforest-starship.toml" ''
    add_newline = false
    format = "$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character"

    [shell]
    disabled = false
    format = "$indicator"
    fish_indicator = "[FISH](#83c092) "
    bash_indicator = "[BASH](#d3c6aa) "
    zsh_indicator  = "[ZSH](#d3c6aa) "

    [username]
    disabled = false
    style_user = "#d3c6aa bold"
    style_root = "#e67e80 bold"

    [hostname]
    disabled = false
    style = "#7fbbb3 bold"

    [directory]
    style = "#7fbbb3 bold"
    truncation_length = 3

    [git_branch]
    style = "#7fbbb3"
    symbol = " "

    [git_status]
    style = "#e67e80"

    [git_commit]
    style = "#a7c080"

    [nix_shell]
    style = "#83c092"
    symbol = " "

    [cmd_duration]
    style = "#dbbc7f"

    [character]
    success_symbol = "[❯](#a7c080)"
    error_symbol   = "[❯](#e67e80)"
  '';
}
