{ pkgs }:
let
  c = import ./colors.nix;
  wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/rose-pine/wallpapers/main/illustration/block-wave-moon.png";
    sha256 = "0l9yj4lq2vxg5zmf3ga6xymj4ffdhy16gsh7y1a9irw9cqzwvsam";
  };
  previewPng = pkgs.runCommand "rosepine-preview.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
    tmp=$(mktemp -d)
    convert "${wallpaper}" -resize 400x370^ -gravity Center -extent 400x370 "$tmp/bg.png"
    convert \
      \( -size 50x30 xc:"${c.base}" \) \( -size 50x30 xc:"${c.text}" \) \
      \( -size 50x30 xc:"${c.iris}" \) \( -size 50x30 xc:"${c.pine}" \) \
      \( -size 50x30 xc:"${c.foam}" \) \( -size 50x30 xc:"${c.rose}" \) \
      \( -size 50x30 xc:"${c.love}" \) \( -size 50x30 xc:"${c.gold}" \) \
      +append "$tmp/swatches.png"
    convert "$tmp/bg.png" "$tmp/swatches.png" -append "$out"
  '';
in
{
  name     = "Rose Pine";
  inherit wallpaper previewPng;
  rofiColors  = { bg = c.base; bg2 = c.overlay; fg = c.text; selected = c.highlightMed; urgent = c.love; };
  dunstColors = { bg2 = c.overlay; fg = c.text; accent = c.iris; red = c.love; };
  waybarCss = ./waybar/style.css;
  gtkTheme  = "rose-pine";
  gtkIcons  = "Papirus-Dark";

  vscodeThemeName = "Rosé Pine";
  vscodeExtension = pkgs.vscode-extensions.mvllow.rose-pine;

  neovimColorscheme = "rose-pine";
  neovimPlugin      = pkgs.vimPlugins.rose-pine;

  kittyColors = pkgs.writeText "rosepine-kitty-colors" ''
    foreground            #e0def4
    background            #191724
    selection_foreground  #e0def4
    selection_background  #403d52
    url_color             #9ccfd8
    cursor                #ebbcba
    color0  #26233a
    color8  #6e6a86
    color1  #eb6f92
    color9  #eb6f92
    color2  #31748f
    color10 #9ccfd8
    color3  #f6c177
    color11 #f6c177
    color4  #31748f
    color12 #c4a7e7
    color5  #c4a7e7
    color13 #c4a7e7
    color6  #9ccfd8
    color14 #9ccfd8
    color7  #908caa
    color15 #e0def4
    active_tab_background   ${c.iris}
    active_tab_foreground   ${c.base}
    inactive_tab_background ${c.overlay}
    inactive_tab_foreground ${c.subtle}
  '';

  tmuxColors = { bg = "#191724"; fg = "#e0def4"; accent = "#c4a7e7"; bg2 = "#26233a"; fgOnAccent = "#191724"; };

  starshipToml = pkgs.writeText "rosepine-starship.toml" ''
    add_newline = false
    format = "$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character"

    [shell]
    disabled = false
    format = "$indicator"
    fish_indicator = "[FISH](#9ccfd8) "
    bash_indicator = "[BASH](#e0def4) "
    zsh_indicator  = "[ZSH](#e0def4) "

    [username]
    disabled = false
    style_user = "#e0def4 bold"
    style_root = "#eb6f92 bold"

    [hostname]
    disabled = false
    style = "#c4a7e7 bold"

    [directory]
    style = "#c4a7e7 bold"
    truncation_length = 3

    [git_branch]
    style = "#c4a7e7"
    symbol = " "

    [git_status]
    style = "#eb6f92"

    [git_commit]
    style = "#9ccfd8"

    [nix_shell]
    style = "#9ccfd8"
    symbol = " "

    [cmd_duration]
    style = "#f6c177"

    [character]
    success_symbol = "[❯](#9ccfd8)"
    error_symbol   = "[❯](#eb6f92)"
  '';
}
