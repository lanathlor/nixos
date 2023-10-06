{ config, lib, pkgs, modulesPath, ... }:

let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixos-unstable)
    # reuse the current configuration
    { config = config.nixpkgs.config; };
in
{
  imports =
    [
      ./waybar/waybar.nix
      ./dunst.nix
    ];

 home-manager.users.lanath = { pkgs, ... }: {
    home.stateVersion = "23.05";

    nixpkgs = {
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
      };
    };

    home.packages = with pkgs; [
      rofi-mpd
      rofi-bluetooth
      rofi-power-menu
      rofi-systemd
      swww
      dmenu
      playerctl
      networkmanagerapplet
      discord
      baobab
      keepassxc
      gparted
    ];

    programs.fish = {
      enable = true;
    };

    programs.kitty = {
      enable = true;
      theme = "Nord";
      keybindings = {
        "ctrl+c" = "copy_or_interrupt";
        "ctrl+v" = "paste_from_clipboard";
        "ctrl+f>2" = "set_font_size 20";
      };
      settings = {
        enable_audio_bell = false;
        update_check_interval = 0;
      };
    };

    programs.starship = {
      enable = true;
    };

    programs.neovim = {
      enable = true;
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.vscode = {
    	enable = true;
      package = unstable.vscode;
    };

    programs.git = {
      enable = true;
      userName  = "lanath";
      userEmail = "valentin.vivier@bhc-it.com";
    };


    programs.swaylock = {
      enable = true;
      settings = {
        ignore-empty-password = true;
        show-failed-attempt = true;
        show-keyboard-layout = true;
        line-uses-ring = true;
        color = "2e3440";
        bs-hl-color = "b48eadff";
        caps-lock-bs-hl-color = "d08770ff";
        caps-lock-key-hl-color = "ebcb8bff";
        indicator-radius = "100";
        indicator-thickness = "10";
        inside-color = "2e3440ff";
        inside-clear-color = "81a1c1ff";
        inside-ver-color = "5e81acff";
        inside-wrong-color = "bf616aff";
        key-hl-color = "a3be8cff";
        layout-bg-color = "2e3440ff";
        ring-color = "3b4252ff";
        ring-clear-color = "88c0d0ff";
        ring-ver-color = "81a1c1ff";
        ring-wrong-color = "d08770ff";
        separator-color = "3b4252ff";
        text-color = "eceff4ff";
        text-clear-color = "3b4252ff";
        text-ver-color = "3b4252ff";
        text-wrong-color = "3b4252ff";
      };
    };

    programs.btop = {
      enable = true;
      settings = {
        color_theme = "TTY";
        theme_background = false;
        truecolor = true;
      };
    };

    programs.wofi = {
      enable = true;
    };

    programs.rofi = {
      enable = true;
      theme = ./nord.rasi;
      package = pkgs.rofi-wayland.override { plugins = with pkgs; [ rofi-power-menu rofi-mpd rofi-bluetooth ]; };
      terminal = "${pkgs.kitty}/bin/kitty";
      plugins = with pkgs; [

        rofi-calc
        rofi-emoji


      ];
      extraConfig = {
        modi = "drun,emoji,ssh,filebrowser,calc";
        case-sensitive = false;
        drun-categories = "";
        drun-match-fields = "name,generic,exec,categories,keywords";
        drun-display-format = "{name} [<span weight='light' size='small'><i>({generic})</i></span>]";
        drun-show-actions = false;
      };
      pass = {
        enable = true;
      };
    };

    programs.mpv = {
      enable = true;
      config = {
        profile = "gpu-hq";
        force-window = true;
        ytdl-format = "bestvideo+bestaudio";
        cache-default = 4000000;
      };
      scripts = with unstable.mpvScripts; [ mpris sponsorblock mpv-playlistmanager quality-menu thumbfast ];
    };

    programs.yt-dlp = {
      enable = true;
    };

    services.playerctld = {
      enable = true;
    };

    services.mpd = {
      enable = true;
    };

    xdg.userDirs.enable = true;

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
        "application/pdf" = ["firefox.desktop"];
        "application/javascript" = ["code.desktop"];
        "text/plain" = ["code.desktop"];
        "text/*" = ["code.desktop"];
        "text/html" = ["code.desktop"];
        "text/xml" = ["code.desktop"];
        "text/javascript" = ["code.desktop"];
        "text/json" = ["code.desktop"];
        "text/x-csrc" = ["code.desktop"]; # ts files
        "image/gif" = ["firefox.desktop"];
        "image/jpeg" = ["firefox.desktop"];
        "image/png" = ["firefox.desktop"];
        "image/webp" = ["firefox.desktop"];
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
      };
    };

    home.file.".config/hypr/hyprland.conf" = {
      text = import ./hypr.nix;
    };

    home.file.".wallpapers/wallpaper.png" = {
      source = ./nord-city.jpeg;
    };

  };
}
