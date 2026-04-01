{ pkgs, lib, ... }:
let
  c = import ./colors.nix;
in
{
  theme.name    = "Catppuccin Mocha";
  theme.wallpaper = ./cat-sound.png;
  theme.neovim = {
    plugin = pkgs.vimPlugins.catppuccin-nvim;
    colorscheme = "catppuccin-mocha";
    lualineTheme = "catppuccin";
  };

  services.dunst.settings = {
    base16_low = {
      frame_color = "${c.mauve}77";
      msg_urgency = "low";
      background = c.surface0;
      foreground = c.subtext1;
    };
    base16_normal = {
      frame_color = "${c.green}77";
      msg_urgency = "normal";
      background = c.surface0;
      foreground = c.subtext1;
    };
    base16_critical = {
      frame_color = "${c.red}77";
      msg_urgency = "critical";
      background = c.surface0;
      foreground = c.subtext1;
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-mocha-mauve-standard";
      package = pkgs.catppuccin-gtk.override { variant = "mocha"; accents = [ "mauve" ]; };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  programs.rofi = {
    theme = ./catppuccin.rasi;
  };

  programs.kitty = {
    themeFile = lib.mkDefault "Catppuccin-Mocha";
  };

  home.file.".wallpapers/wallpaper.png" = {
    source = ./cat-sound.png;
  };

  # ── Tmux Catppuccin Mocha theme ──────────────────────────────────────────────
  programs.tmux.extraConfig = ''
    set -g status-style    "bg=${c.base},fg=${c.text}"
    set -g status-interval 2
    set -g status-left        "#[bg=${c.base},fg=${c.mauve}]#[bg=${c.mauve},fg=${c.base},bold] #S #[bg=${c.base},fg=${c.mauve}] "
    set -g status-left-length 30
    set -g status-right        " #[bg=${c.base},fg=${c.mauve}]#[bg=${c.mauve},fg=${c.base}]  %H:%M    %d %b #[bg=${c.base},fg=${c.mauve}]"
    set -g status-right-length 40
    set -g window-status-style         "bg=${c.base}"
    set -g window-status-current-style "bg=${c.base}"
    set -g window-status-separator     ""
    set -g window-status-format \
      "#[bg=${c.base},fg=${c.surface0}]#[bg=${c.surface0},fg=${c.text}] #I  #W #{?#{==:#{@test_status},pass}, #[fg=${c.green}]✓,}#{?#{==:#{@test_status},fail}, #[fg=${c.red}]✗,} #[bg=${c.base},fg=${c.surface0}]"
    set -g window-status-current-format \
      "#[bg=${c.base},fg=${c.mauve}]#[bg=${c.mauve},fg=${c.base},bold] #I  #W #{?#{==:#{@test_status},pass}, #[fg=${c.green}]✓,}#{?#{==:#{@test_status},fail}, #[fg=${c.red}]✗,} #[bg=${c.base},fg=${c.mauve}]"
    set -g pane-border-style        "fg=${c.surface0}"
    set -g pane-active-border-style "fg=${c.mauve}"
    set -g message-style         "bg=${c.surface0},fg=${c.text}"
    set -g message-command-style "bg=${c.surface0},fg=${c.text}"
    set -g mode-style "bg=${c.mauve},fg=${c.base}"
  '';

  # ── Lazygit Catppuccin theme ─────────────────────────────────────────────────
  programs.lazygit.settings = {
    gui = {
      nerdFontsVersion = "3";
      theme = {
        activeBorderColor         = [ c.mauve "bold" ];
        inactiveBorderColor       = [ c.surface2 ];
        optionsTextColor          = [ c.blue ];
        selectedLineBgColor       = [ c.surface0 ];
        selectedRangeBgColor      = [ c.surface0 ];
        cherryPickedCommitBgColor = [ c.mauve ];
        cherryPickedCommitFgColor = [ c.base ];
        unstagedChangesColor      = [ c.red ];
        defaultFgColor            = [ c.text ];
        searchingActiveBorderColor = [ c.yellow "bold" ];
      };
    };
  };

  # ── Btop Catppuccin theme ────────────────────────────────────────────────────
  programs.btop.settings = {
    color_theme = "catppuccin_mocha";
    theme_background = false;
    truecolor = true;
  };

  # Neovim theme plugin is now installed by registry.nix (owns all theme plugins)
}
