{ pkgs }:
let
  c = import ./colors.nix;
  wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/AngelJumbo/gruvbox-wallpapers/main/wallpapers/minimalistic/gruvbox_astro.jpg";
    sha256 = "0kfm6g3h5rmlbz0dba18avzpvy3wlxbrp31s8f3902ysxcip4g31";
  };
  previewPng = pkgs.runCommand "gruvbox-preview.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
    tmp=$(mktemp -d)
    convert "${wallpaper}" -resize 400x195^ -gravity Center -extent 400x195 "$tmp/bg.png"
    convert \
      \( -size 50x30 xc:"#282828" \) \( -size 50x30 xc:"#ebdbb2" \) \
      \( -size 50x30 xc:"#458588" \) \( -size 50x30 xc:"#b8bb26" \) \
      \( -size 50x30 xc:"#fabd2f" \) \( -size 50x30 xc:"#fb4934" \) \
      \( -size 50x30 xc:"#b16286" \) \( -size 50x30 xc:"#689d6a" \) \
      +append "$tmp/swatches.png"
    convert "$tmp/bg.png" "$tmp/swatches.png" -append "$out"
  '';
in
{
  name     = "Gruvbox";
  inherit wallpaper previewPng;
  rofiColors  = { bg = "#282828"; bg2 = "#3c3836"; fg = "#ebdbb2"; selected = "#504945"; urgent = "#cc241d"; };
  dunstColors = { bg2 = "#3c3836"; fg = "#ebdbb2"; accent = "#458588"; red = "#fb4934"; };
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
    color0  #282828
    color8  #928374
    color1  #cc241d
    color9  #fb4934
    color2  #98971a
    color10 #b8bb26
    color3  #d79921
    color11 #fabd2f
    color4  #458588
    color12 #83a598
    color5  #b16286
    color13 #d3869b
    color6  #689d6a
    color14 #8ec07c
    color7  #a89984
    color15 #ebdbb2
    active_tab_background   #458588
    active_tab_foreground   #282828
    inactive_tab_background #3c3836
    inactive_tab_foreground #a89984
  '';

  tmuxColors = { bg = "#282828"; fg = "#ebdbb2"; accent = "#458588"; bg2 = "#3c3836"; fgOnAccent = "#ebdbb2"; };

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
