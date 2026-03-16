{ pkgs, lib, ... }:
let
  nord = import ./nordic/meta.nix { inherit pkgs; };
  # To add a new theme later: dracula = import ./dracula/meta.nix { inherit pkgs; };

  allThemes = [ nord ];

  applyCase = t: ''
    "${t.name}")
      swww img "${t.wallpaper}"
      ln -sf "${t.waybarCss}" "$HOME/.config/waybar/style.css"
      pkill -SIGUSR2 waybar || true
      if tmux info &>/dev/null 2>&1; then
        tmux source-file "${t.tmuxConf}" || true
      fi
      for _sock in /tmp/kitty-*; do
        [ -S "$_sock" ] && kitty @ --to "unix:$_sock" \
          set-colors -a "${t.kittyColors}" 2>/dev/null || true
      done
      for _sock in "/run/user/$(id -u)/nvim."*; do
        [ -S "$_sock" ] && nvim --server "$_sock" \
          --remote-send ":colorscheme ${t.neovimColorscheme}<CR>" 2>/dev/null || true
      done
      gsettings set org.gnome.desktop.interface gtk-theme "${t.gtkTheme}"
      gsettings set org.gnome.desktop.interface icon-theme "${t.gtkIcons}"
      printf '%s' "${t.name}" > "$HOME/.cache/current-theme"
      notify-send "󰏘 Theme" "Switched to ${t.name}" --icon=preferences-desktop-theme
    ;;
  '';

  themeNames = lib.concatStringsSep "\\n" (map (t: t.name) allThemes);
  themeBlock  = lib.concatStrings (map applyCase allThemes);
in
{
  # Install all theme neovim plugins so :colorscheme works after live switch
  programs.neovim.plugins = map (t: t.neovimPlugin) allThemes;

  home.packages = [
    (pkgs.writeShellApplication {
      name = "theme-switch";
      runtimeInputs = with pkgs; [ swww tmux glib libnotify procps coreutils ];
      # kitty, nvim, rofi come from home-manager; bare names work fine
      text = ''
        SELECTED=$(printf "${themeNames}" \
          | rofi -dmenu -i -p "󰏘  Theme" -theme-str 'window{width:300px;}') || exit 0
        case "$SELECTED" in
          ${themeBlock}
          *) exit 1 ;;
        esac
      '';
    })
  ];
}
