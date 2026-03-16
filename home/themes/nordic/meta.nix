{ pkgs }:
let
  c = import ./colors.nix;
  previewPng = pkgs.runCommand "nord-preview.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
    tmp=$(mktemp -d)
    convert "${./nord-city.jpeg}" -resize 400x195^ -gravity Center -extent 400x195 "$tmp/bg.png"
    convert \
      \( -size 50x30 xc:"${c.nord0}"  \) \( -size 50x30 xc:"${c.nord4}"  \) \
      \( -size 50x30 xc:"${c.nord8}"  \) \( -size 50x30 xc:"${c.nord9}"  \) \
      \( -size 50x30 xc:"${c.nord10}" \) \( -size 50x30 xc:"${c.nord14}" \) \
      \( -size 50x30 xc:"${c.nord11}" \) \( -size 50x30 xc:"${c.nord13}" \) \
      +append "$tmp/swatches.png"
    convert "$tmp/bg.png" "$tmp/swatches.png" -append "$out"
  '';
in
{
  name     = "Nord";
  inherit previewPng;
  rofiColors  = { bg = c.nord0; bg2 = c.nord1; fg = c.nord4; selected = c.nord3; urgent = c.nord11; };
  dunstColors = { bg2 = c.nord1; fg = c.nord5; accent = c.nord10; red = c.nord11; };
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
    color0   ${c.nord1}
    color8   ${c.nord3}
    color1   ${c.nord11}
    color9   ${c.nord11}
    color2   ${c.nord14}
    color10  ${c.nord14}
    color3   ${c.nord13}
    color11  ${c.nord13}
    color4   ${c.nord9}
    color12  ${c.nord9}
    color5   ${c.nord15}
    color13  ${c.nord15}
    color6   ${c.nord8}
    color14  ${c.nord7}
    color7   ${c.nord5}
    color15  ${c.nord6}
    active_tab_background   ${c.nord10}
    active_tab_foreground   ${c.nord0}
    inactive_tab_background ${c.nord1}
    inactive_tab_foreground ${c.nord4}
  '';

  starshipToml = pkgs.writeText "nord-starship.toml" ''
    add_newline = false
    format = "$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character"

    [shell]
    disabled = false
    format = "$indicator"
    fish_indicator = "[FISH](${c.nord8}) "
    bash_indicator = "[BASH](${c.nord6}) "
    zsh_indicator  = "[ZSH](${c.nord6}) "

    [username]
    disabled = false
    style_user = "${c.nord6} bold"
    style_root = "${c.nord11} bold"

    [hostname]
    disabled = false
    style = "${c.nord9} bold"

    [directory]
    style = "${c.nord10} bold"
    truncation_length = 3

    [git_branch]
    style = "${c.nord8}"
    symbol = " "

    [git_status]
    style = "${c.nord11}"

    [git_commit]
    style = "${c.nord14}"

    [nix_shell]
    style = "${c.nord9}"
    symbol = " "

    [cmd_duration]
    style = "${c.nord13}"

    [character]
    success_symbol = "[❯](${c.nord14})"
    error_symbol   = "[❯](${c.nord11})"
  '';

  tmuxColors = { bg = c.nord0; fg = c.nord4; accent = c.nord10; bg2 = c.nord1; fgOnAccent = c.nord6; };
}
