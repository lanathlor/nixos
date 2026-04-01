{ pkgs }:
let
  c = import ./colors.nix;
  wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Apeiros-46B/everforest-walls/main/nature/mist_forest_1.png";
    sha256 = "17b1q72ds17mz4pgs1dwqy8spdlkssshdhj00hdprwsl815rssxl";
  };
  previewPng = pkgs.runCommand "everforest-preview.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
    tmp=$(mktemp -d)
    convert "${wallpaper}" -resize 400x370^ -gravity Center -extent 400x370 "$tmp/bg.png"
    convert \
      \( -size 50x30 xc:"${c.bg0}"    \) \( -size 50x30 xc:"${c.fg}"     \) \
      \( -size 50x30 xc:"${c.green}"  \) \( -size 50x30 xc:"${c.blue}"   \) \
      \( -size 50x30 xc:"${c.purple}" \) \( -size 50x30 xc:"${c.red}"    \) \
      \( -size 50x30 xc:"${c.yellow}" \) \( -size 50x30 xc:"${c.orange}" \) \
      +append "$tmp/swatches.png"
    convert "$tmp/bg.png" "$tmp/swatches.png" -append "$out"
  '';
in
{
  name     = "Everforest";
  inherit wallpaper previewPng;
  rofiColors  = { bg = c.bg0; bg2 = c.bg2; fg = c.fg; selected = c.bg3; urgent = c.red; };
  dunstColors = { bg2 = c.bg2; fg = c.fg; accent = c.blue; red = c.red; };
  waybarCss = ./waybar/style.css;
  gtkTheme  = "Everforest-Dark-B";
  gtkIcons  = "Papirus-Dark";

  vscodeThemeName = "Everforest Dark";
  vscodeExtension = builtins.head (pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
    publisher = "sainnhe";
    name = "everforest";
    version = "0.3.0";
    sha256 = "1dbkk2nys97a825kvrmjh6qgjzfricllwjwh9qcsvmycbg6sp64x";
  }]);

  neovimColorscheme = "everforest";
  neovimPlugin      = pkgs.vimPlugins.everforest;

  kittyColors = pkgs.writeText "everforest-kitty-colors" ''
    foreground            #d3c6aa
    background            #2d353b
    selection_foreground  #2d353b
    selection_background  #475258
    url_color             #7fbbb3
    cursor                #d3c6aa
    color0  #2d353b
    color8  #475258
    color1  #e67e80
    color9  #e67e80
    color2  #a7c080
    color10 #a7c080
    color3  #dbbc7f
    color11 #dbbc7f
    color4  #7fbbb3
    color12 #7fbbb3
    color5  #d699b6
    color13 #d699b6
    color6  #83c092
    color14 #83c092
    color7  #859289
    color15 #d3c6aa
    active_tab_background   ${c.blue}
    active_tab_foreground   ${c.bg0}
    inactive_tab_background ${c.bg2}
    inactive_tab_foreground ${c.fg}
  '';

  tmuxColors = { bg = "#2d353b"; fg = "#d3c6aa"; accent = "#7fbbb3"; bg2 = "#3d484d"; fgOnAccent = "#2d353b"; };

  swaylockColors = {
    bg = c.bg0; bg2 = c.bg2; fg = c.fg;
    accent = c.blue; clear = c.aqua; wrong = c.red;
    green = c.green; purple = c.purple; yellow = c.yellow; orange = c.orange;
  };

  starshipToml = pkgs.writeText "everforest-starship.toml" ''
    add_newline = false
    format = "$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character"

    [shell]
    disabled = false
    format = "$indicator"
    fish_indicator = "[FISH](#83c092) "
    bash_indicator = "[BASH](#d3c6aa) "
    zsh_indicator  = "[ZSH](#d3c6aa) "

    [username]
    disabled = false
    style_user = "#d3c6aa bold"
    style_root = "#e67e80 bold"

    [hostname]
    disabled = false
    style = "#7fbbb3 bold"

    [directory]
    style = "#7fbbb3 bold"
    truncation_length = 3

    [git_branch]
    style = "#7fbbb3"
    symbol = " "

    [git_status]
    style = "#e67e80"

    [git_commit]
    style = "#a7c080"

    [nix_shell]
    style = "#83c092"
    symbol = " "

    [cmd_duration]
    style = "#dbbc7f"

    [character]
    success_symbol = "[❯](#a7c080)"
    error_symbol   = "[❯](#e67e80)"
  '';
}
