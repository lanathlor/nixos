{ pkgs }:
let
  c = import ./colors.nix;
  wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Narmis-E/onedark-wallpapers/main/minimal/od_wave.png";
    sha256 = "17q5x63jr8r1wpzy5sw6vpqqw1gf1c2vzwmzm0dkh02kbf0wr6ib";
  };
  previewPng = pkgs.runCommand "onedark-preview.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
    tmp=$(mktemp -d)
    convert "${wallpaper}" -resize 400x370^ -gravity Center -extent 400x370 "$tmp/bg.png"
    convert \
      \( -size 50x30 xc:"${c.bg}"     \) \( -size 50x30 xc:"${c.fg}"     \) \
      \( -size 50x30 xc:"${c.blue}"   \) \( -size 50x30 xc:"${c.purple}"  \) \
      \( -size 50x30 xc:"${c.green}"  \) \( -size 50x30 xc:"${c.red}"     \) \
      \( -size 50x30 xc:"${c.yellow}" \) \( -size 50x30 xc:"${c.cyan}"    \) \
      +append "$tmp/swatches.png"
    convert "$tmp/bg.png" "$tmp/swatches.png" -append "$out"
  '';
in
{
  name     = "One Dark";
  inherit wallpaper previewPng;
  rofiColors  = { bg = c.bg; bg2 = c.bg4; fg = c.fg; selected = c.bg3; urgent = c.red; };
  dunstColors = { bg2 = c.bg4; fg = c.fg; accent = c.blue; red = c.red; };
  waybarCss = ./waybar/style.css;
  gtkTheme  = "Adwaita-dark";
  gtkIcons  = "Papirus-Dark";

  vscodeThemeName = "One Dark Pro";
  vscodeExtension = pkgs.vscode-extensions.zhuangtongfa.material-theme;

  neovimColorscheme = "onedark";
  neovimPlugin      = pkgs.vimPlugins.onedark-nvim;

  kittyColors = pkgs.writeText "onedark-kitty-colors" ''
    foreground            #abb2bf
    background            #282c34
    selection_foreground  #282c34
    selection_background  #323842
    url_color             #61afef
    cursor                #abb2bf
    color0  #282c34
    color8  #5c6370
    color1  #e06c75
    color9  #e06c75
    color2  #98c379
    color10 #98c379
    color3  #e5c07b
    color11 #e5c07b
    color4  #61afef
    color12 #61afef
    color5  #c678dd
    color13 #c678dd
    color6  #56b6c2
    color14 #56b6c2
    color7  #abb2bf
    color15 #c8ccd4
    active_tab_background   ${c.blue}
    active_tab_foreground   ${c.bg}
    inactive_tab_background ${c.bg4}
    inactive_tab_foreground ${c.fg}
  '';

  tmuxColors = { bg = "#282c34"; fg = "#abb2bf"; accent = "#61afef"; bg2 = "#3b4048"; fgOnAccent = "#282c34"; };

  swaylockColors = {
    bg = c.bg; bg2 = c.bg4; fg = c.fg;
    accent = c.blue; clear = c.cyan; wrong = c.red;
    green = c.green; purple = c.purple; yellow = c.yellow; orange = c.orange;
  };

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
