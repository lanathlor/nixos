{ config, lib, pkgs, ... }:

with lib;

{
  options.modules.games.warcraftlogs = {
    enable = mkEnableOption "Warcraft Logs - Upload and analyze World of Warcraft combat logs";
  };

  config = mkIf config.modules.games.warcraftlogs.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "warcraftlogs"
    ];

    environment.systemPackages = with pkgs; [
      warcraftlogs
    ];
  };
}
