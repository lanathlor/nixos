{ config, ... }:
let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixos-unstable)
    # reuse the current configuration
    { config = config.nixpkgs.config; };
in
{
  home-manager.users.lanath = {
    programs.waybar = {
      enable = true;
      package = unstable.waybar;
      systemd = {
        enable = true;
        target = "basic.target";
      };
    };

    xdg.configFile."waybar" = {
      source = ./files;
      recursive = true;
    };

  };
}