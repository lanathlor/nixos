{ pkgs }:
let c = import ./colors.nix; in
{
  name     = "Gruvbox";
  wallpaper = pkgs.runCommand "gruvbox-wallpaper.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
    convert -size 1920x1080 gradient:"#282828-#504945" $out
  '';
  waybarCss = ./waybar/style.css;
  gtkTheme  = "Gruvbox-Dark";
  gtkIcons  = "Papirus-Dark";

  neovimColorscheme = "gruvbox";
  neovimPlugin      = pkgs.vimPlugins.gruvbox-nvim;

  kittyColors = pkgs.writeText "gruvbox-kitty-colors" ''
    foreground            #ebdbb2
    background            #282828
    selection_foreground  #282828
    selection_background  #665c54
    url_color             #83a598
    cursor                #d5c4a1
    color0  #282828   color8  #928374
    color1  #cc241d   color9  #fb4934
    color2  #98971a   color10 #b8bb26
    color3  #d79921   color11 #fabd2f
    color4  #458588   color12 #83a598
    color5  #b16286   color13 #d3869b
    color6  #689d6a   color14 #8ec07c
    color7  #a89984   color15 #ebdbb2
  '';

  tmuxConf = pkgs.writeText "gruvbox-tmux-colors" ''
    set -g status-style    "bg=#282828,fg=#ebdbb2"
    set -g status-interval 2
    set -g status-left        "#[bg=#282828,fg=#458588]#[bg=#458588,fg=#ebdbb2,bold] #S #[bg=#282828,fg=#458588] "
    set -g status-left-length 30
    set -g status-right        " #[bg=#282828,fg=#458588]#[bg=#458588,fg=#ebdbb2]  %H:%M    %d %b #[bg=#282828,fg=#458588]"
    set -g status-right-length 40
    set -g window-status-style         "bg=#282828"
    set -g window-status-current-style "bg=#282828"
    set -g window-status-separator     ""
    set -g window-status-format \
      "#[bg=#282828,fg=#3c3836]#[bg=#3c3836,fg=#ebdbb2] #I  #W #[bg=#282828,fg=#3c3836]"
    set -g window-status-current-format \
      "#[bg=#282828,fg=#458588]#[bg=#458588,fg=#ebdbb2,bold] #I  #W #[bg=#282828,fg=#458588]"
    set -g pane-border-style        "fg=#3c3836"
    set -g pane-active-border-style "fg=#458588"
    set -g message-style            "bg=#3c3836,fg=#ebdbb2"
    set -g message-command-style    "bg=#3c3836,fg=#ebdbb2"
    set -g mode-style               "bg=#458588,fg=#ebdbb2"
  '';

  starshipToml = pkgs.writeText "gruvbox-starship.toml" ''
    add_newline = false
    format = "$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character"

    [shell]
    disabled = false
    format = "$indicator"
    fish_indicator = "[FISH](#8ec07c) "
    bash_indicator = "[BASH](#ebdbb2) "
    zsh_indicator  = "[ZSH](#ebdbb2) "

    [username]
    disabled = false
    style_user = "#ebdbb2 bold"
    style_root = "#fb4934 bold"

    [hostname]
    disabled = false
    style = "#458588 bold"

    [directory]
    style = "#458588 bold"
    truncation_length = 3

    [git_branch]
    style = "#458588"
    symbol = " "

    [git_status]
    style = "#fb4934"

    [git_commit]
    style = "#b8bb26"

    [nix_shell]
    style = "#83a598"
    symbol = " "

    [cmd_duration]
    style = "#fabd2f"

    [character]
    success_symbol = "[❯](#b8bb26)"
    error_symbol   = "[❯](#fb4934)"
  '';
}
