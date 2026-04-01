{ pkgs }:
let
  c = import ./colors.nix;
  wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/tokyo-night/wallpapers/main/night/abstract/lockscreen_00_1920x1080.png";
    sha256 = "1i643ff83wgbvjvm2w1rzry13zj2ffjanmkhhfchxvk1q4rz6gfp";
  };
  previewPng = pkgs.runCommand "tokyonight-preview.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
    tmp=$(mktemp -d)
    convert "${wallpaper}" -resize 400x370^ -gravity Center -extent 400x370 "$tmp/bg.png"
    convert \
      \( -size 50x30 xc:"${c.bg}"      \) \( -size 50x30 xc:"${c.fg}"      \) \
      \( -size 50x30 xc:"${c.blue}"    \) \( -size 50x30 xc:"${c.magenta}"  \) \
      \( -size 50x30 xc:"${c.green}"   \) \( -size 50x30 xc:"${c.red}"      \) \
      \( -size 50x30 xc:"${c.yellow}"  \) \( -size 50x30 xc:"${c.cyan}"     \) \
      +append "$tmp/swatches.png"
    convert "$tmp/bg.png" "$tmp/swatches.png" -append "$out"
  '';
in
{
  name     = "Tokyo Night";
  inherit wallpaper previewPng;
  rofiColors  = { bg = c.bg; bg2 = c.bgHighlight; fg = c.fg; selected = c.terminalBlack; urgent = c.red; };
  dunstColors = { bg2 = c.bgHighlight; fg = c.fgDark; accent = c.magenta; red = c.red; };
  waybarCss = ./waybar/style.css;
  gtkTheme  = "Adwaita-dark";
  gtkIcons  = "Papirus-Dark";

  vscodeThemeName = "Tokyo Night";
  vscodeExtension = pkgs.vscode-extensions.enkia.tokyo-night;

  neovimColorscheme = "tokyonight-night";
  neovimPlugin      = pkgs.vimPlugins.tokyonight-nvim;

  kittyColors = pkgs.writeText "tokyonight-kitty-colors" ''
    foreground            #c0caf5
    background            #1a1b26
    selection_foreground  #1a1b26
    selection_background  #292e42
    url_color             #7aa2f7
    cursor                #c0caf5
    color0  #16161e
    color8  #414868
    color1  #f7768e
    color9  #f7768e
    color2  #9ece6a
    color10 #9ece6a
    color3  #e0af68
    color11 #e0af68
    color4  #7aa2f7
    color12 #7aa2f7
    color5  #bb9af7
    color13 #bb9af7
    color6  #7dcfff
    color14 #7dcfff
    color7  #a9b1d6
    color15 #c0caf5
    active_tab_background   ${c.magenta}
    active_tab_foreground   ${c.bg}
    inactive_tab_background ${c.bgHighlight}
    inactive_tab_foreground ${c.fgDark}
  '';

  tmuxColors = { bg = "#1a1b26"; fg = "#c0caf5"; accent = "#bb9af7"; bg2 = "#292e42"; fgOnAccent = "#1a1b26"; };

  swaylockColors = {
    bg = c.bg; bg2 = c.bgHighlight; fg = c.fg;
    accent = c.blue; clear = c.cyan; wrong = c.red;
    green = c.green; purple = c.magenta; yellow = c.yellow; orange = c.orange;
  };

  starshipToml = pkgs.writeText "tokyonight-starship.toml" ''
    add_newline = false
    format = "$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character"

    [shell]
    disabled = false
    format = "$indicator"
    fish_indicator = "[FISH](#7dcfff) "
    bash_indicator = "[BASH](#c0caf5) "
    zsh_indicator  = "[ZSH](#c0caf5) "

    [username]
    disabled = false
    style_user = "#c0caf5 bold"
    style_root = "#f7768e bold"

    [hostname]
    disabled = false
    style = "#7aa2f7 bold"

    [directory]
    style = "#bb9af7 bold"
    truncation_length = 3

    [git_branch]
    style = "#bb9af7"
    symbol = " "

    [git_status]
    style = "#f7768e"

    [git_commit]
    style = "#9ece6a"

    [nix_shell]
    style = "#7aa2f7"
    symbol = " "

    [cmd_duration]
    style = "#e0af68"

    [character]
    success_symbol = "[❯](#9ece6a)"
    error_symbol   = "[❯](#f7768e)"
  '';
}
