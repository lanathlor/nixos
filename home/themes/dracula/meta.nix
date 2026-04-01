{ pkgs }:
let
  c = import ./colors.nix;
  wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/dracula/wallpaper/master/big.png";
    sha256 = "1grnijvcg3y6706nwnlrcmphkmi8lwczidq8xilchzc020pglggl";
  };
  previewPng = pkgs.runCommand "dracula-preview.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
    tmp=$(mktemp -d)
    convert "${wallpaper}" -resize 400x370^ -gravity Center -extent 400x370 "$tmp/bg.png"
    convert \
      \( -size 50x30 xc:"#282a36" \) \( -size 50x30 xc:"#f8f8f2" \) \
      \( -size 50x30 xc:"#bd93f9" \) \( -size 50x30 xc:"#8be9fd" \) \
      \( -size 50x30 xc:"#50fa7b" \) \( -size 50x30 xc:"#ff5555" \) \
      \( -size 50x30 xc:"#f1fa8c" \) \( -size 50x30 xc:"#ff79c6" \) \
      +append "$tmp/swatches.png"
    convert "$tmp/bg.png" "$tmp/swatches.png" -append "$out"
  '';
in
{
  name     = "Dracula";
  inherit wallpaper previewPng;
  rofiColors  = { bg = "#282a36"; bg2 = "#44475a"; fg = "#f8f8f2"; selected = "#6272a4"; urgent = "#ff5555"; };
  dunstColors = { bg2 = "#44475a"; fg = "#f8f8f2"; accent = "#bd93f9"; red = "#ff5555"; };
  waybarCss = ./waybar/style.css;
  gtkTheme  = "Dracula";
  gtkIcons  = "Papirus-Dark";

  vscodeThemeName = "Dracula";
  vscodeExtension = pkgs.vscode-extensions.dracula-theme.theme-dracula;

  neovimColorscheme = "dracula";
  neovimPlugin      = pkgs.vimPlugins.dracula-nvim;

  kittyColors = pkgs.writeText "dracula-kitty-colors" ''
    foreground            #f8f8f2
    background            #282a36
    selection_foreground  #282a36
    selection_background  #44475a
    url_color             #8be9fd
    cursor                #f8f8f2
    color0  #21222c
    color8  #6272a4
    color1  #ff5555
    color9  #ff5555
    color2  #50fa7b
    color10 #50fa7b
    color3  #f1fa8c
    color11 #f1fa8c
    color4  #bd93f9
    color12 #bd93f9
    color5  #ff79c6
    color13 #ff79c6
    color6  #8be9fd
    color14 #8be9fd
    color7  #f8f8f2
    color15 #f8f8f2
    active_tab_background   #bd93f9
    active_tab_foreground   #282a36
    inactive_tab_background #44475a
    inactive_tab_foreground #f8f8f2
  '';

  tmuxColors = { bg = "#282a36"; fg = "#f8f8f2"; accent = "#bd93f9"; bg2 = "#44475a"; fgOnAccent = "#282a36"; };

  swaylockColors = {
    bg = c.bg; bg2 = c.currentLine; fg = c.fg;
    accent = c.purple; clear = c.cyan; wrong = c.red;
    green = c.green; purple = c.pink; yellow = c.yellow; orange = c.orange;
  };

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
