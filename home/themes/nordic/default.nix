{ pkgs, ... }:
let
  c = import ./colors.nix;
in
{
  imports = [
    ./waybar
  ];

  theme.name    = "Nord";
  theme.wallpaper = ./nord-city.jpeg;
  theme.neovim = {
    plugin = pkgs.vimPlugins.nord-nvim;
    colorscheme = "nord";
    lualineTheme = "nord";
  };

  programs.kitty.extraConfig = "include ~/.config/kitty/current-theme.conf";

  # ── Tmux Nord theme ─────────────────────────────────────────────────────────
  programs.tmux.extraConfig = ''
    # ── Nord / Waybar-aligned theme ─────────────────────────────────
    set -g status-style    "bg=${c.nord0},fg=${c.nord4}"
    set -g status-interval 2

    # Session pill — nord10 accent, mirrors waybar clock module
    set -g status-left        "#[bg=${c.nord0},fg=${c.nord10}]#[bg=${c.nord10},fg=${c.nord6},bold] #S #[bg=${c.nord0},fg=${c.nord10}] "
    set -g status-left-length 30

    # Time pill (right)
    set -g status-right        " #[bg=${c.nord0},fg=${c.nord10}]#[bg=${c.nord10},fg=${c.nord6}]  %H:%M    %d %b #[bg=${c.nord0},fg=${c.nord10}]"
    set -g status-right-length 40

    # Window pills — inactive: subtle nord1 pill
    set -g window-status-style         "bg=${c.nord0}"
    set -g window-status-current-style "bg=${c.nord0}"
    set -g window-status-separator     ""

    set -g window-status-format \
      "#[bg=${c.nord0},fg=${c.nord1}]#[bg=${c.nord1},fg=${c.nord4}] #I  #W#{?#{==:#{@test_status},pass}, #[fg=${c.nord14}]✓,}#{?#{==:#{@test_status},fail}, #[fg=${c.nord11}]✗,} #[bg=${c.nord0},fg=${c.nord1}]"

    # Window pills — active: nord8 accent pill
    set -g window-status-current-format \
      "#[bg=${c.nord0},fg=${c.nord8}]#[bg=${c.nord8},fg=${c.nord0},bold] #I  #W#{?#{==:#{@test_status},pass}, #[fg=${c.nord14}]✓,}#{?#{==:#{@test_status},fail}, #[fg=${c.nord11}]✗,} #[bg=${c.nord0},fg=${c.nord8}]"

    set -g pane-border-style        "fg=${c.nord1}"
    set -g pane-active-border-style "fg=${c.nord10}"

    set -g message-style         "bg=${c.nord1},fg=${c.nord4}"
    set -g message-command-style "bg=${c.nord1},fg=${c.nord4}"

    set -g mode-style "bg=${c.nord8},fg=${c.nord0}"
  '';

  # ── Lazygit Nord theme ───────────────────────────────────────────────────────
  programs.lazygit.settings = {
    gui = {
      nerdFontsVersion = "3";
      theme = {
        activeBorderColor         = [ c.nord8 "bold" ];
        inactiveBorderColor       = [ c.nord3 ];
        optionsTextColor          = [ c.nord9 ];
        selectedLineBgColor       = [ c.nord1 ];
        selectedRangeBgColor      = [ c.nord1 ];
        cherryPickedCommitBgColor = [ c.nord10 ];
        cherryPickedCommitFgColor = [ c.nord6 ];
        unstagedChangesColor      = [ c.nord11 ];
        defaultFgColor            = [ c.nord4 ];
        searchingActiveBorderColor = [ c.nord13 "bold" ];
      };
    };
  };

  # ── Btop Nord theme ──────────────────────────────────────────────────────────
  programs.btop.settings = {
    color_theme = "nord";
    theme_background = false;
    truecolor = true;
  };

  # Neovim theme plugin is now installed by registry.nix (owns all theme plugins)
}
