{ pkgs-unstable, pkgs, lib, ... }:
{

  home.packages = with pkgs; [
    rofi-mpd
    rofi-bluetooth
    rofi-power-menu
    rofi-systemd
  ];

  programs.rofi = {
    enable = true;
    terminal = lib.mkDefault "${pkgs.kitty}/bin/kitty";
    extraConfig = lib.mkDefault {
      modi = "drun,emoji,ssh,filebrowser,calc";
      case-sensitive = false;
      drun-categories = "";
      drun-match-fields = "name,generic,exec,categories,keywords";
      drun-display-format = "{name} [<span weight='light' size='small'><i>({generic})</i></span>]";
      drun-show-actions = false;
    };
    font = "Noto Sans Mono";
    pass = {
      enable = true;
    };
    package = pkgs-unstable.rofi-wayland.override { plugins = with pkgs; [ rofi-power-menu rofi-mpd rofi-bluetooth ]; };
    plugins = with pkgs; lib.mkDefault [
      rofi-calc
      rofi-emoji
    ];
  };
}
