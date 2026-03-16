{ pkgs }:
let c = import ./colors.nix; in
{
  name     = "Tokyo Night";
  wallpaper = pkgs.runCommand "tokyonight-wallpaper.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
    convert -size 1920x1080 gradient:"#1a1b26-#24283b" $out
  '';
  waybarCss = ./waybar/style.css;
  gtkTheme  = "Adwaita-dark";
  gtkIcons  = "Papirus-Dark";

  neovimColorscheme = "tokyonight-night";
  neovimPlugin      = pkgs.vimPlugins.tokyonight-nvim;

  kittyColors = pkgs.writeText "tokyonight-kitty-colors" ''
    foreground            #c0caf5
    background            #1a1b26
    selection_foreground  #1a1b26
    selection_background  #292e42
    url_color             #7aa2f7
    cursor                #c0caf5
    color0  #16161e   color8  #414868
    color1  #f7768e   color9  #f7768e
    color2  #9ece6a   color10 #9ece6a
    color3  #e0af68   color11 #e0af68
    color4  #7aa2f7   color12 #7aa2f7
    color5  #bb9af7   color13 #bb9af7
    color6  #7dcfff   color14 #7dcfff
    color7  #a9b1d6   color15 #c0caf5
  '';

  tmuxConf = pkgs.writeText "tokyonight-tmux-colors" ''
    set -g status-style    "bg=#1a1b26,fg=#c0caf5"
    set -g status-interval 2
    set -g status-left        "#[bg=#1a1b26,fg=#bb9af7]#[bg=#bb9af7,fg=#1a1b26,bold] #S #[bg=#1a1b26,fg=#bb9af7] "
    set -g status-left-length 30
    set -g status-right        " #[bg=#1a1b26,fg=#bb9af7]#[bg=#bb9af7,fg=#1a1b26]  %H:%M    %d %b #[bg=#1a1b26,fg=#bb9af7]"
    set -g status-right-length 40
    set -g window-status-style         "bg=#1a1b26"
    set -g window-status-current-style "bg=#1a1b26"
    set -g window-status-separator     ""
    set -g window-status-format \
      "#[bg=#1a1b26,fg=#292e42]#[bg=#292e42,fg=#c0caf5] #I  #W #[bg=#1a1b26,fg=#292e42]"
    set -g window-status-current-format \
      "#[bg=#1a1b26,fg=#bb9af7]#[bg=#bb9af7,fg=#1a1b26,bold] #I  #W #[bg=#1a1b26,fg=#bb9af7]"
    set -g pane-border-style        "fg=#292e42"
    set -g pane-active-border-style "fg=#bb9af7"
    set -g message-style            "bg=#292e42,fg=#c0caf5"
    set -g message-command-style    "bg=#292e42,fg=#c0caf5"
    set -g mode-style               "bg=#bb9af7,fg=#1a1b26"
  '';

  starshipToml = pkgs.writeText "tokyonight-starship.toml" ''
    add_newline = false
    format = "$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character"

    [shell]
    disabled = false
    format = "$indicator"
    fish_indicator = "[FISH](#7dcfff) "
    bash_indicator = "[BASH](#c0caf5) "
    zsh_indicator  = "[ZSH](#c0caf5) "

    [username]
    disabled = false
    style_user = "#c0caf5 bold"
    style_root = "#f7768e bold"

    [hostname]
    disabled = false
    style = "#7aa2f7 bold"

    [directory]
    style = "#bb9af7 bold"
    truncation_length = 3

    [git_branch]
    style = "#bb9af7"
    symbol = " "

    [git_status]
    style = "#f7768e"

    [git_commit]
    style = "#9ece6a"

    [nix_shell]
    style = "#7aa2f7"
    symbol = " "

    [cmd_duration]
    style = "#e0af68"

    [character]
    success_symbol = "[❯](#9ece6a)"
    error_symbol   = "[❯](#f7768e)"
  '';
}
