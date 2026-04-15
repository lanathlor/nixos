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
