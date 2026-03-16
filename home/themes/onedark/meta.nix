{ pkgs }:
let c = import ./colors.nix; in
{
  name     = "One Dark";
  wallpaper = pkgs.runCommand "onedark-wallpaper.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
    convert -size 1920x1080 gradient:"#282c34-#3b4048" $out
  '';
  waybarCss = ./waybar/style.css;
  gtkTheme  = "Adwaita-dark";
  gtkIcons  = "Papirus-Dark";

  neovimColorscheme = "onedark";
  neovimPlugin      = pkgs.vimPlugins.onedark-nvim;

  kittyColors = pkgs.writeText "onedark-kitty-colors" ''
    foreground            #abb2bf
    background            #282c34
    selection_foreground  #282c34
    selection_background  #323842
    url_color             #61afef
    cursor                #abb2bf
    color0  #282c34   color8  #5c6370
    color1  #e06c75   color9  #e06c75
    color2  #98c379   color10 #98c379
    color3  #e5c07b   color11 #e5c07b
    color4  #61afef   color12 #61afef
    color5  #c678dd   color13 #c678dd
    color6  #56b6c2   color14 #56b6c2
    color7  #abb2bf   color15 #c8ccd4
  '';

  tmuxConf = pkgs.writeText "onedark-tmux-colors" ''
    set -g status-style    "bg=#282c34,fg=#abb2bf"
    set -g status-interval 2
    set -g status-left        "#[bg=#282c34,fg=#61afef]#[bg=#61afef,fg=#282c34,bold] #S #[bg=#282c34,fg=#61afef] "
    set -g status-left-length 30
    set -g status-right        " #[bg=#282c34,fg=#61afef]#[bg=#61afef,fg=#282c34]  %H:%M    %d %b #[bg=#282c34,fg=#61afef]"
    set -g status-right-length 40
    set -g window-status-style         "bg=#282c34"
    set -g window-status-current-style "bg=#282c34"
    set -g window-status-separator     ""
    set -g window-status-format \
      "#[bg=#282c34,fg=#3b4048]#[bg=#3b4048,fg=#abb2bf] #I  #W #[bg=#282c34,fg=#3b4048]"
    set -g window-status-current-format \
      "#[bg=#282c34,fg=#61afef]#[bg=#61afef,fg=#282c34,bold] #I  #W #[bg=#282c34,fg=#61afef]"
    set -g pane-border-style        "fg=#3b4048"
    set -g pane-active-border-style "fg=#61afef"
    set -g message-style            "bg=#3b4048,fg=#abb2bf"
    set -g message-command-style    "bg=#3b4048,fg=#abb2bf"
    set -g mode-style               "bg=#61afef,fg=#282c34"
  '';

  starshipToml = pkgs.writeText "onedark-starship.toml" ''
    add_newline = false
    format = "$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character"

    [shell]
    disabled = false
    format = "$indicator"
    fish_indicator = "[FISH](#56b6c2) "
    bash_indicator = "[BASH](#abb2bf) "
    zsh_indicator  = "[ZSH](#abb2bf) "

    [username]
    disabled = false
    style_user = "#abb2bf bold"
    style_root = "#e06c75 bold"

    [hostname]
    disabled = false
    style = "#c678dd bold"

    [directory]
    style = "#61afef bold"
    truncation_length = 3

    [git_branch]
    style = "#61afef"
    symbol = " "

    [git_status]
    style = "#e06c75"

    [git_commit]
    style = "#98c379"

    [nix_shell]
    style = "#61afef"
    symbol = " "

    [cmd_duration]
    style = "#e5c07b"

    [character]
    success_symbol = "[❯](#98c379)"
    error_symbol   = "[❯](#e06c75)"
  '';
}
