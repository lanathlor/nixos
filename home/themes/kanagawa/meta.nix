{ pkgs }:
let c = import ./colors.nix; in
{
  name     = "Kanagawa";
  wallpaper = pkgs.runCommand "kanagawa-wallpaper.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
    convert -size 1920x1080 gradient:"#1F1F28-#363646" $out
  '';
  waybarCss = ./waybar/style.css;
  gtkTheme  = "Adwaita-dark";
  gtkIcons  = "Papirus-Dark";

  neovimColorscheme = "kanagawa-wave";
  neovimPlugin      = pkgs.vimPlugins.kanagawa-nvim;

  kittyColors = pkgs.writeText "kanagawa-kitty-colors" ''
    foreground            #DCD7BA
    background            #1F1F28
    selection_foreground  #DCD7BA
    selection_background  #363646
    url_color             #7E9CD8
    cursor                #C8C093
    color0  #16161D   color8  #727169
    color1  #E46876   color9  #E46876
    color2  #98BB6C   color10 #98BB6C
    color3  #C0A36E   color11 #E6C384
    color4  #7E9CD8   color12 #7E9CD8
    color5  #957FB8   color13 #957FB8
    color6  #7AA89F   color14 #7AA89F
    color7  #C8C093   color15 #DCD7BA
  '';

  tmuxConf = pkgs.writeText "kanagawa-tmux-colors" ''
    set -g status-style    "bg=#1F1F28,fg=#DCD7BA"
    set -g status-interval 2
    set -g status-left        "#[bg=#1F1F28,fg=#7E9CD8]#[bg=#7E9CD8,fg=#1F1F28,bold] #S #[bg=#1F1F28,fg=#7E9CD8] "
    set -g status-left-length 30
    set -g status-right        " #[bg=#1F1F28,fg=#7E9CD8]#[bg=#7E9CD8,fg=#1F1F28]  %H:%M    %d %b #[bg=#1F1F28,fg=#7E9CD8]"
    set -g status-right-length 40
    set -g window-status-style         "bg=#1F1F28"
    set -g window-status-current-style "bg=#1F1F28"
    set -g window-status-separator     ""
    set -g window-status-format \
      "#[bg=#1F1F28,fg=#2A2A37]#[bg=#2A2A37,fg=#DCD7BA] #I  #W #[bg=#1F1F28,fg=#2A2A37]"
    set -g window-status-current-format \
      "#[bg=#1F1F28,fg=#7E9CD8]#[bg=#7E9CD8,fg=#1F1F28,bold] #I  #W #[bg=#1F1F28,fg=#7E9CD8]"
    set -g pane-border-style        "fg=#2A2A37"
    set -g pane-active-border-style "fg=#7E9CD8"
    set -g message-style            "bg=#2A2A37,fg=#DCD7BA"
    set -g message-command-style    "bg=#2A2A37,fg=#DCD7BA"
    set -g mode-style               "bg=#7E9CD8,fg=#1F1F28"
  '';

  starshipToml = pkgs.writeText "kanagawa-starship.toml" ''
    add_newline = false
    format = "$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character"

    [shell]
    disabled = false
    format = "$indicator"
    fish_indicator = "[FISH](#7AA89F) "
    bash_indicator = "[BASH](#DCD7BA) "
    zsh_indicator  = "[ZSH](#DCD7BA) "

    [username]
    disabled = false
    style_user = "#DCD7BA bold"
    style_root = "#E46876 bold"

    [hostname]
    disabled = false
    style = "#7E9CD8 bold"

    [directory]
    style = "#7E9CD8 bold"
    truncation_length = 3

    [git_branch]
    style = "#7E9CD8"
    symbol = " "

    [git_status]
    style = "#E46876"

    [git_commit]
    style = "#98BB6C"

    [nix_shell]
    style = "#7AA89F"
    symbol = " "

    [cmd_duration]
    style = "#C0A36E"

    [character]
    success_symbol = "[❯](#98BB6C)"
    error_symbol   = "[❯](#E46876)"
  '';
}
