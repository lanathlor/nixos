{ pkgs }:
let
  c = import ./colors.nix;
in
{
  name     = "Nord";
  wallpaper = ./nord-city.jpeg;
  waybarCss = ./waybar/style.css;
  gtkTheme  = "Nordic";
  gtkIcons  = "Papirus-Dark";

  neovimColorscheme = "nord";
  neovimPlugin      = pkgs.vimPlugins.nord-nvim;

  kittyColors = pkgs.writeText "nord-kitty-colors" ''
    foreground            ${c.nord6}
    background            ${c.nord0}
    selection_foreground  ${c.nord0}
    selection_background  ${c.nord3}
    url_color             ${c.nord8}
    cursor                ${c.nord4}
    color0  ${c.nord1}  color8   ${c.nord3}
    color1  ${c.nord11} color9   ${c.nord11}
    color2  ${c.nord14} color10  ${c.nord14}
    color3  ${c.nord13} color11  ${c.nord13}
    color4  ${c.nord9}  color12  ${c.nord9}
    color5  ${c.nord15} color13  ${c.nord15}
    color6  ${c.nord8}  color14  ${c.nord7}
    color7  ${c.nord5}  color15  ${c.nord6}
  '';

  tmuxConf = pkgs.writeText "nord-tmux-colors" ''
    set -g status-style    "bg=${c.nord0},fg=${c.nord4}"
    set -g status-interval 2
    set -g status-left        "#[bg=${c.nord0},fg=${c.nord10}]#[bg=${c.nord10},fg=${c.nord6},bold] #S #[bg=${c.nord0},fg=${c.nord10}] "
    set -g status-left-length 30
    set -g status-right        " #[bg=${c.nord0},fg=${c.nord10}]#[bg=${c.nord10},fg=${c.nord6}]  %H:%M    %d %b #[bg=${c.nord0},fg=${c.nord10}]"
    set -g status-right-length 40
    set -g window-status-style         "bg=${c.nord0}"
    set -g window-status-current-style "bg=${c.nord0}"
    set -g window-status-separator     ""
    set -g window-status-format \
      "#[bg=${c.nord0},fg=${c.nord1}]#[bg=${c.nord1},fg=${c.nord4}] #I  #W #[bg=${c.nord0},fg=${c.nord1}]"
    set -g window-status-current-format \
      "#[bg=${c.nord0},fg=${c.nord8}]#[bg=${c.nord8},fg=${c.nord0},bold] #I  #W #[bg=${c.nord0},fg=${c.nord8}]"
    set -g pane-border-style        "fg=${c.nord1}"
    set -g pane-active-border-style "fg=${c.nord10}"
    set -g message-style            "bg=${c.nord1},fg=${c.nord4}"
    set -g message-command-style    "bg=${c.nord1},fg=${c.nord4}"
    set -g mode-style               "bg=${c.nord8},fg=${c.nord0}"
  '';
}
