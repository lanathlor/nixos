{ pkgs }:
let c = import ./colors.nix; in
{
  name     = "Rose Pine";
  wallpaper = pkgs.runCommand "rosepine-wallpaper.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
    convert -size 1920x1080 gradient:"#191724-#26233a" $out
  '';
  waybarCss = ./waybar/style.css;
  gtkTheme  = "rose-pine";
  gtkIcons  = "Papirus-Dark";

  neovimColorscheme = "rose-pine";
  neovimPlugin      = pkgs.vimPlugins.rose-pine;

  kittyColors = pkgs.writeText "rosepine-kitty-colors" ''
    foreground            #e0def4
    background            #191724
    selection_foreground  #e0def4
    selection_background  #403d52
    url_color             #9ccfd8
    cursor                #ebbcba
    color0  #26233a   color8  #6e6a86
    color1  #eb6f92   color9  #eb6f92
    color2  #31748f   color10 #9ccfd8
    color3  #f6c177   color11 #f6c177
    color4  #31748f   color12 #c4a7e7
    color5  #c4a7e7   color13 #c4a7e7
    color6  #9ccfd8   color14 #9ccfd8
    color7  #908caa   color15 #e0def4
  '';

  tmuxConf = pkgs.writeText "rosepine-tmux-colors" ''
    set -g status-style    "bg=#191724,fg=#e0def4"
    set -g status-interval 2
    set -g status-left        "#[bg=#191724,fg=#c4a7e7]#[bg=#c4a7e7,fg=#191724,bold] #S #[bg=#191724,fg=#c4a7e7] "
    set -g status-left-length 30
    set -g status-right        " #[bg=#191724,fg=#c4a7e7]#[bg=#c4a7e7,fg=#191724]  %H:%M    %d %b #[bg=#191724,fg=#c4a7e7]"
    set -g status-right-length 40
    set -g window-status-style         "bg=#191724"
    set -g window-status-current-style "bg=#191724"
    set -g window-status-separator     ""
    set -g window-status-format \
      "#[bg=#191724,fg=#26233a]#[bg=#26233a,fg=#e0def4] #I  #W #[bg=#191724,fg=#26233a]"
    set -g window-status-current-format \
      "#[bg=#191724,fg=#c4a7e7]#[bg=#c4a7e7,fg=#191724,bold] #I  #W #[bg=#191724,fg=#c4a7e7]"
    set -g pane-border-style        "fg=#26233a"
    set -g pane-active-border-style "fg=#c4a7e7"
    set -g message-style            "bg=#26233a,fg=#e0def4"
    set -g message-command-style    "bg=#26233a,fg=#e0def4"
    set -g mode-style               "bg=#c4a7e7,fg=#191724"
  '';

  starshipToml = pkgs.writeText "rosepine-starship.toml" ''
    add_newline = false
    format = "$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character"

    [shell]
    disabled = false
    format = "$indicator"
    fish_indicator = "[FISH](#9ccfd8) "
    bash_indicator = "[BASH](#e0def4) "
    zsh_indicator  = "[ZSH](#e0def4) "

    [username]
    disabled = false
    style_user = "#e0def4 bold"
    style_root = "#eb6f92 bold"

    [hostname]
    disabled = false
    style = "#c4a7e7 bold"

    [directory]
    style = "#c4a7e7 bold"
    truncation_length = 3

    [git_branch]
    style = "#c4a7e7"
    symbol = " "

    [git_status]
    style = "#eb6f92"

    [git_commit]
    style = "#9ccfd8"

    [nix_shell]
    style = "#9ccfd8"
    symbol = " "

    [cmd_duration]
    style = "#f6c177"

    [character]
    success_symbol = "[❯](#9ccfd8)"
    error_symbol   = "[❯](#eb6f92)"
  '';
}
