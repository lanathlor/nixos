{ config, lib, pkgs, modulesPath, ... }:

let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixos-unstable)
    # reuse the current configuration
    { config = config.nixpkgs.config; };
in
{

  home-manager.users.mushu = { pkgs, ... }: {
    imports = [
      ./dunst.nix
      ../common/home.nix
      ../common/vscode.nix
    ];

    home.packages = with pkgs; [
      rofi-mpd
      rofi-bluetooth
      rofi-power-menu
      rofi-systemd
      discord
    ];

    programs.fish = {
      shellAliases = {
        k = "kubectl";
        kssh = "kitten ssh";
      };
    };

    programs.git = {
      enable = true;
      userName = "mushu";
    };

    programs.kitty = {
      theme = lib.mkDefault "Nord";
    };

    programs.rofi = {
      theme = ./nord.rasi;
      package = unstable.rofi-wayland.override { plugins = with pkgs; [ rofi-power-menu rofi-mpd rofi-bluetooth ]; };
      plugins = with pkgs; lib.mkDefault [
        rofi-calc
        rofi-emoji
      ];
    };

    gtk = {
      enable = true;
      theme = {
        name = "Nordic";
        package = pkgs.nordic;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    };

    xdg.mimeApps = {
      associations.added = {
        "text/plain" = [ "code.desktop" ];
      };
      defaultApplications = {
        "application/pdf" = [ "firefox.desktop" ];
        "application/javascript" = [ "code.desktop" ];
        "text/plain" = [ "code.desktop" ];
        "text/*" = [ "code.desktop" ];
        "text/html" = [ "code.desktop" ];
        "text/xml" = [ "code.desktop" ];
        "text/javascript" = [ "code.desktop" ];
        "text/json" = [ "code.desktop" ];
        "text/x-csrc" = [ "code.desktop" ]; # ts files
        "image/gif" = [ "firefox.desktop" ];
        "image/jpeg" = [ "firefox.desktop" ];
        "image/png" = [ "firefox.desktop" ];
        "image/webp" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];
        "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];
        "x-scheme-handler/sms" = [ "thunderbird.desktop" ];
        "x-scheme-handler/mms" = [ "thunderbird.desktop" ];
        "x-scheme-handler/chrome" = [ "thunderbird.desktop" ];
        "x-scheme-handler/spotify" = [ "spotify.desktop" ];
        "x-scheme-handler/steam" = [ "steam.desktop" ];
      };
    };

    home.file.".wallpapers/wallpaper.png" = {
      source = ./nord-city.jpeg;
    };
  };
}
