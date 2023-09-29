{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [
      ./waybar/waybar.nix
      ./dunst.nix
    ];

 home-manager.users.lanath = { pkgs, ... }: {
    home.stateVersion = "23.05";

    home.packages = with pkgs; [ ];

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.fish = {
      enable = true;
    };

    programs.neovim = {
      enable = true;
    };

    programs.git = {
      enable = true;
      userName  = "lanath";
      userEmail = "valentin.vivier@bhc-it.com";
    };

    programs.kitty = {
      enable = true;
      theme = "Nord";
      keybindings = {
        "ctrl+c" = "copy_or_interrupt";
        "ctrl+v" = "copy";
        "ctrl+f>2" = "set_font_size 20";
      };
      settings = {
        enable_audio_bell = false;
        update_check_interval = 0;
      };
    };

    programs.wofi = {
      enable = true;
    };

    programs.rofi = {
      enable = true;
      theme = ./nord.rasi;
      plugins = with pkgs; [
        rofi-power-menu
        rofi-calc
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

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };

    xdg.mimeApps = {
      enable = true;
      associations.added = {
        "text/plain" = ["code.desktop"];
      };
      defaultApplications = {
        "text/plain" = ["code.desktop"];
        "text/html" = ["firefox.desktop"];
        "text/xml" = ["firefox.desktop"];
        "x-scheme-handler/http" = ["firefox.desktop"];
        "x-scheme-handler/https" = ["firefox.desktop"];
        "x-scheme-handler/about" = ["firefox.desktop"];
        "x-scheme-handler/unknown" = ["firefox.desktop"];
        "x-scheme-handler/mailto" = ["thunderbird.desktop"];
        "x-scheme-handler/sms" = ["thunderbird.desktop"];
        "x-scheme-handler/mms" = ["thunderbird.desktop"];
        "x-scheme-handler/chrome" = ["thunderbird.desktop"];
        "x-scheme-handler/spotify" = ["spotify.desktop"];
        "x-scheme-handler/steam" = ["steam.desktop"];
        "application/pdf" = ["firefox.desktop"];
      };
    };

    home.file.".config/hypr/hyprland.conf" = {
      text = import ./hypr.nix;
    };

  };
}