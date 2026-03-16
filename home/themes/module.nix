{ lib, ... }:
{
  options.theme = {
    name     = lib.mkOption { type = lib.types.str; };
    wallpaper = lib.mkOption { type = lib.types.path; };
    neovim = {
      plugin = lib.mkOption { type = lib.types.package; };
      colorscheme = lib.mkOption { type = lib.types.str; };
      lualineTheme = lib.mkOption { type = lib.types.str; };
    };
  };
}
