{ config, lib, pkgs, modulesPath, ... }:

let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixos-unstable)
    { config = config.nixpkgs.config; };
in
{

  home-manager.users.lanath = { pkgs, ... }: {
    imports = [
      ./dunst.nix
      ./waybar/waybar.nix
      ../common/home.nix
      ../common/vscode.nix
    ];

    home.packages = with pkgs; [
      rofi-mpd
      rofi-bluetooth
      rofi-power-menu
      rofi-systemd
      unstable.discord
      unstable.dorion
    ];


    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = import ./hypr.nix;
    };

    programs.swaylock = {
      enable = true;
      settings = lib.mkDefault {
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

    programs.fish = {
      shellAliases = {
        k = "kubectl";
        d = "docker";
        g = "git";
        kssh = "kitten ssh";
      };
    };

    programs.git = {
      enable = true;
      userName = "lanath";
      userEmail = "valentin@viviersoft.com";
      ignores = [
        "node_modules"
        "out"
        "*.log"
        "*.sqlite"
        "*.envrc"
        "*.pem"
        "*.key"
        "*.crt"
        "*.csr"
        "*.pfx"
        "*.cer"
        "*.jks"
        "*.keystore"
        "*~"
        ".direnv"
        ".envrc"
        "*tfstate*"
        ".terraform"
      ];
      extraConfig = {
        pull.rebase = true;
      };
      signing = {
        signByDefault = true;
        key = "B3319E23B4F37099073FD764AC81A86C4854A64B";
      };
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
    programs.ssh = {
      matchBlocks =
        {
          "git.node.master.monkey" = {
            hostname = "git.node.master.monkey";
            user = "git";
            port = 2222;
            identityFile = "/home/lanath/.ssh/id_rsa";
          };
          "git.node.master-monkey.com" = {
            hostname = "git.node.master-monkey.com";
            user = "git";
            port = 2222;
            identityFile = "/home/lanath/.ssh/id_rsa";
          };
        };
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
