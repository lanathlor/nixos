{ pkgs }:
let
  c = import ./colors.nix;
  previewPng = pkgs.runCommand "catppuccin-preview.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
    tmp=$(mktemp -d)
    convert "${./cat-sound.png}" -resize 400x370^ -gravity Center -extent 400x370 "$tmp/bg.png"
    convert \
      \( -size 50x30 xc:"${c.base}"   \) \( -size 50x30 xc:"${c.text}"   \) \
      \( -size 50x30 xc:"${c.mauve}"  \) \( -size 50x30 xc:"${c.blue}"   \) \
      \( -size 50x30 xc:"${c.green}"  \) \( -size 50x30 xc:"${c.red}"    \) \
      \( -size 50x30 xc:"${c.yellow}" \) \( -size 50x30 xc:"${c.teal}"   \) \
      +append "$tmp/swatches.png"
    convert "$tmp/bg.png" "$tmp/swatches.png" -append "$out"
  '';
in
{
  name     = "Catppuccin Mocha";
  inherit previewPng;
  rofiColors  = { bg = c.base; bg2 = c.surface0; fg = c.text; selected = c.surface2; urgent = c.red; };
  dunstColors = { bg2 = c.surface0; fg = c.subtext1; accent = c.mauve; red = c.red; };
  wallpaper = ./cat-sound.png;
  waybarCss = ./waybar/style.css;
  gtkTheme  = "catppuccin-mocha-mauve-standard";
  gtkIcons  = "Papirus-Dark";

  vscodeThemeName = "Catppuccin Mocha";
  vscodeExtension = pkgs.vscode-extensions.catppuccin.catppuccin-vsc;

  neovimColorscheme = "catppuccin-mocha";
  neovimPlugin      = pkgs.vimPlugins.catppuccin-nvim;

  kittyColors = pkgs.writeText "catppuccin-mocha-kitty-colors" ''
    foreground            ${c.text}
    background            ${c.base}
    selection_foreground  ${c.text}
    selection_background  ${c.surface2}
    url_color             ${c.blue}
    cursor                ${c.rosewater}
    color0  ${c.surface1}
    color8  ${c.surface2}
    color1  ${c.red}
    color9  ${c.red}
    color2  ${c.green}
    color10 ${c.green}
    color3  ${c.yellow}
    color11 ${c.yellow}
    color4  ${c.blue}
    color12 ${c.blue}
    color5  ${c.pink}
    color13 ${c.pink}
    color6  ${c.teal}
    color14 ${c.teal}
    color7  ${c.subtext1}
    color15 ${c.text}
    active_tab_background   ${c.mauve}
    active_tab_foreground   ${c.base}
    inactive_tab_background ${c.surface0}
    inactive_tab_foreground ${c.subtext1}
  '';

  starshipToml = pkgs.writeText "catppuccin-mocha-starship.toml" ''
    add_newline = false
    format = "$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character"

    [shell]
    disabled = false
    format = "$indicator"
    fish_indicator = "[FISH](${c.sky}) "
    bash_indicator = "[BASH](${c.text}) "
    zsh_indicator  = "[ZSH](${c.text}) "

    [username]
    disabled = false
    style_user = "${c.text} bold"
    style_root = "${c.red} bold"

    [hostname]
    disabled = false
    style = "${c.blue} bold"

    [directory]
    style = "${c.blue} bold"
    truncation_length = 3

    [git_branch]
    style = "${c.mauve}"
    symbol = " "

    [git_status]
    style = "${c.red}"

    [git_commit]
    style = "${c.green}"

    [nix_shell]
    style = "${c.teal}"
    symbol = " "

    [cmd_duration]
    style = "${c.yellow}"

    [character]
    success_symbol = "[❯](${c.green})"
    error_symbol   = "[❯](${c.red})"
  '';

  tmuxColors = { bg = c.base; fg = c.text; accent = c.mauve; bg2 = c.surface0; fgOnAccent = c.base; };
}
