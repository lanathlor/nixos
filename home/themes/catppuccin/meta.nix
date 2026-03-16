{ pkgs }:
let
  c = import ./colors.nix;
in
{
  name     = "Catppuccin Mocha";
  wallpaper = ./cat-sound.png;
  waybarCss = ./waybar/style.css;
  gtkTheme  = "catppuccin-mocha-mauve-standard";
  gtkIcons  = "Papirus-Dark";

  neovimColorscheme = "catppuccin-mocha";
  neovimPlugin      = pkgs.vimPlugins.catppuccin-nvim;

  kittyColors = pkgs.writeText "catppuccin-mocha-kitty-colors" ''
    foreground            ${c.text}
    background            ${c.base}
    selection_foreground  ${c.text}
    selection_background  ${c.surface2}
    url_color             ${c.blue}
    cursor                ${c.rosewater}
    color0  ${c.surface1}  color8  ${c.surface2}
    color1  ${c.red}       color9  ${c.red}
    color2  ${c.green}     color10 ${c.green}
    color3  ${c.yellow}    color11 ${c.yellow}
    color4  ${c.blue}      color12 ${c.blue}
    color5  ${c.pink}      color13 ${c.pink}
    color6  ${c.teal}      color14 ${c.teal}
    color7  ${c.subtext1}  color15 ${c.text}
  '';

  tmuxConf = pkgs.writeText "catppuccin-mocha-tmux-colors" ''
    set -g status-style    "bg=${c.base},fg=${c.text}"
    set -g status-interval 2
    set -g status-left        "#[bg=${c.base},fg=${c.mauve}]#[bg=${c.mauve},fg=${c.base},bold] #S #[bg=${c.base},fg=${c.mauve}] "
    set -g status-left-length 30
    set -g status-right        " #[bg=${c.base},fg=${c.mauve}]#[bg=${c.mauve},fg=${c.base}]  %H:%M    %d %b #[bg=${c.base},fg=${c.mauve}]"
    set -g status-right-length 40
    set -g window-status-style         "bg=${c.base}"
    set -g window-status-current-style "bg=${c.base}"
    set -g window-status-separator     ""
    set -g window-status-format \
      "#[bg=${c.base},fg=${c.surface0}]#[bg=${c.surface0},fg=${c.text}] #I  #W #[bg=${c.base},fg=${c.surface0}]"
    set -g window-status-current-format \
      "#[bg=${c.base},fg=${c.mauve}]#[bg=${c.mauve},fg=${c.base},bold] #I  #W #[bg=${c.base},fg=${c.mauve}]"
    set -g pane-border-style        "fg=${c.surface0}"
    set -g pane-active-border-style "fg=${c.mauve}"
    set -g message-style            "bg=${c.surface0},fg=${c.text}"
    set -g message-command-style    "bg=${c.surface0},fg=${c.text}"
    set -g mode-style               "bg=${c.mauve},fg=${c.base}"
  '';
}
