{ pkgs }:
let c = import ./colors.nix; in
{
  name     = "Dracula";
  wallpaper = pkgs.runCommand "dracula-wallpaper.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
    convert -size 1920x1080 gradient:"#282a36-#44475a" $out
  '';
  waybarCss = ./waybar/style.css;
  gtkTheme  = "Dracula";
  gtkIcons  = "Papirus-Dark";

  neovimColorscheme = "dracula";
  neovimPlugin      = pkgs.vimPlugins.dracula-nvim;

  kittyColors = pkgs.writeText "dracula-kitty-colors" ''
    foreground            #f8f8f2
    background            #282a36
    selection_foreground  #282a36
    selection_background  #44475a
    url_color             #8be9fd
    cursor                #f8f8f2
    color0  #21222c   color8  #6272a4
    color1  #ff5555   color9  #ff5555
    color2  #50fa7b   color10 #50fa7b
    color3  #f1fa8c   color11 #f1fa8c
    color4  #bd93f9   color12 #bd93f9
    color5  #ff79c6   color13 #ff79c6
    color6  #8be9fd   color14 #8be9fd
    color7  #f8f8f2   color15 #f8f8f2
  '';

  tmuxConf = pkgs.writeText "dracula-tmux-colors" ''
    set -g status-style    "bg=#282a36,fg=#f8f8f2"
    set -g status-interval 2
    set -g status-left        "#[bg=#282a36,fg=#bd93f9]#[bg=#bd93f9,fg=#282a36,bold] #S #[bg=#282a36,fg=#bd93f9] "
    set -g status-left-length 30
    set -g status-right        " #[bg=#282a36,fg=#bd93f9]#[bg=#bd93f9,fg=#282a36]  %H:%M    %d %b #[bg=#282a36,fg=#bd93f9]"
    set -g status-right-length 40
    set -g window-status-style         "bg=#282a36"
    set -g window-status-current-style "bg=#282a36"
    set -g window-status-separator     ""
    set -g window-status-format \
      "#[bg=#282a36,fg=#44475a]#[bg=#44475a,fg=#f8f8f2] #I  #W #[bg=#282a36,fg=#44475a]"
    set -g window-status-current-format \
      "#[bg=#282a36,fg=#bd93f9]#[bg=#bd93f9,fg=#282a36,bold] #I  #W #[bg=#282a36,fg=#bd93f9]"
    set -g pane-border-style        "fg=#44475a"
    set -g pane-active-border-style "fg=#bd93f9"
    set -g message-style            "bg=#44475a,fg=#f8f8f2"
    set -g message-command-style    "bg=#44475a,fg=#f8f8f2"
    set -g mode-style               "bg=#bd93f9,fg=#282a36"
  '';

  starshipToml = pkgs.writeText "dracula-starship.toml" ''
    add_newline = false
    format = "$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character"

    [shell]
    disabled = false
    format = "$indicator"
    fish_indicator = "[FISH](#8be9fd) "
    bash_indicator = "[BASH](#f8f8f2) "
    zsh_indicator  = "[ZSH](#f8f8f2) "

    [username]
    disabled = false
    style_user = "#f8f8f2 bold"
    style_root = "#ff5555 bold"

    [hostname]
    disabled = false
    style = "#bd93f9 bold"

    [directory]
    style = "#bd93f9 bold"
    truncation_length = 3

    [git_branch]
    style = "#bd93f9"
    symbol = " "

    [git_status]
    style = "#ff5555"

    [git_commit]
    style = "#50fa7b"

    [nix_shell]
    style = "#8be9fd"
    symbol = " "

    [cmd_duration]
    style = "#f1fa8c"

    [character]
    success_symbol = "[❯](#50fa7b)"
    error_symbol   = "[❯](#ff5555)"
  '';
}
