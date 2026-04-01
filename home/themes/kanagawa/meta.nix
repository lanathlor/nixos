{ pkgs }:
let
  c = import ./colors.nix;
  wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Gurjaka/Kanagawa-Wallpapers/main/wallpapers/great_wave_of_kanagawa.jpg";
    sha256 = "0l6i89004q0m5nqpx7szw7m2s8l793niay30aawc7w2d5cdngbgc";
  };
  previewPng = pkgs.runCommand "kanagawa-preview.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
    tmp=$(mktemp -d)
    convert "${wallpaper}" -resize 400x370^ -gravity Center -extent 400x370 "$tmp/bg.png"
    convert \
      \( -size 50x30 xc:"${c.sumiInk1}"    \) \( -size 50x30 xc:"${c.fujiWhite}"   \) \
      \( -size 50x30 xc:"${c.crystalBlue}" \) \( -size 50x30 xc:"${c.oniViolet}"   \) \
      \( -size 50x30 xc:"${c.springGreen}" \) \( -size 50x30 xc:"${c.carpYellow}"  \) \
      \( -size 50x30 xc:"${c.waveRed}"     \) \( -size 50x30 xc:"${c.waveAqua}"    \) \
      +append "$tmp/swatches.png"
    convert "$tmp/bg.png" "$tmp/swatches.png" -append "$out"
  '';
in
{
  name     = "Kanagawa";
  inherit wallpaper previewPng;
  rofiColors  = { bg = "#1F1F28"; bg2 = "#2A2A37"; fg = "#DCD7BA"; selected = "#363646"; urgent = "#E46876"; };
  dunstColors = { bg2 = "#2A2A37"; fg = "#DCD7BA"; accent = "#7E9CD8"; red = "#E46876"; };
  waybarCss = ./waybar/style.css;
  gtkTheme  = "Adwaita-dark";
  gtkIcons  = "Papirus-Dark";

  vscodeThemeName = "Kanagawa Wave";
  vscodeExtension = builtins.head (pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
    publisher = "qufiwefefwoyn";
    name = "kanagawa";
    version = "1.5.1";
    sha256 = "0mwgbdis84npl8lhrxkrsi82y6igx9l975jnd37ziz8afyhs4q80";
  }]);

  neovimColorscheme = "kanagawa-wave";
  neovimPlugin      = pkgs.vimPlugins.kanagawa-nvim;

  kittyColors = pkgs.writeText "kanagawa-kitty-colors" ''
    foreground            #DCD7BA
    background            #1F1F28
    selection_foreground  #DCD7BA
    selection_background  #363646
    url_color             #7E9CD8
    cursor                #C8C093
    color0  #16161D
    color8  #727169
    color1  #E46876
    color9  #E46876
    color2  #98BB6C
    color10 #98BB6C
    color3  #C0A36E
    color11 #E6C384
    color4  #7E9CD8
    color12 #7E9CD8
    color5  #957FB8
    color13 #957FB8
    color6  #7AA89F
    color14 #7AA89F
    color7  #C8C093
    color15 #DCD7BA
    active_tab_background   #7E9CD8
    active_tab_foreground   #1F1F28
    inactive_tab_background #2A2A37
    inactive_tab_foreground #C8C093
  '';

  tmuxColors = { bg = "#1F1F28"; fg = "#DCD7BA"; accent = "#7E9CD8"; bg2 = "#2A2A37"; fgOnAccent = "#1F1F28"; };

  starshipToml = pkgs.writeText "kanagawa-starship.toml" ''
    add_newline = false
    format = "$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character"

    [shell]
    disabled = false
    format = "$indicator"
    fish_indicator = "[FISH](#7AA89F) "
    bash_indicator = "[BASH](#DCD7BA) "
    zsh_indicator  = "[ZSH](#DCD7BA) "

    [username]
    disabled = false
    style_user = "#DCD7BA bold"
    style_root = "#E46876 bold"

    [hostname]
    disabled = false
    style = "#7E9CD8 bold"

    [directory]
    style = "#7E9CD8 bold"
    truncation_length = 3

    [git_branch]
    style = "#7E9CD8"
    symbol = " "

    [git_status]
    style = "#E46876"

    [git_commit]
    style = "#98BB6C"

    [nix_shell]
    style = "#7AA89F"
    symbol = " "

    [cmd_duration]
    style = "#C0A36E"

    [character]
    success_symbol = "[❯](#98BB6C)"
    error_symbol   = "[❯](#E46876)"
  '';
}
