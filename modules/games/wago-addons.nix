{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.games.wago-addons = {
    enable = mkEnableOption "Wago Addons - World of Warcraft addon manager";
  };

  config = mkIf config.modules.games.wago-addons.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "wago-addons"
    ];

    environment.systemPackages = with pkgs; [
      wago-addons
    ];
  };
}
