{ config, lib, pkgs, modulesPath, ... }:

let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixos-unstable)
    # reuse the current configuration
    { config = config.nixpkgs.config; };

  flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
  hyprland = (import flake-compat {
    src = builtins.fetchTarball "https://github.com/hyprwm/Hyprland/archive/master.tar.gz";
  }).defaultNix;

in
{

  home-manager.users.lanath = { pkgs, ... }: {
    imports = [
      ./dunst.nix
      ./waybar/waybar.nix
      ../common/home.nix
    ];

    home.packages = with pkgs; [
        rofi-mpd
        rofi-bluetooth
        rofi-power-menu
        rofi-systemd
        discord
        unstable.dorion
    ];


    wayland.windowManager.hyprland = {
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

    programs.vscode = {
      enable = true;
      package = unstable.vscode;
      userSettings = {
        "editor.renderWhitespace" = "trailing";
        "files.trimFinalNewlines" = true;
        "files.trimTrailingWhitespace" = true;
        "git.enableSmartCommit" = true;
        "git.confirmSync" = false;
        "javascript.updateImportsOnFileMove.enabled" = "always";
        "vs-kubernetes" = {
        };
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "editor.formatOnSave" = true;
        "[javascript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[typescript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "editor.codeActionsOnSave" = {
          "source.fixAll.eslint" = true;
        };
        "eslint.validate" = ["javascript" "typescript"];
        "prettier.jsxSingleQuote" = true;
        "prettier.printWidth" = 100;
        "prettier.semi" = false;
        "prettier.singleQuote" = true;
        "prettier.singleAttributePerLine" = true;
        "prettier.tabWidth" = 4;
        "prettier.useTabs" = true;
        "explorer.confirmDragAndDrop" = false;
        "prettier.ignorePath" = "~/.prettierignore";
        "git.autofetch" = true;
        "debug.onTaskErrors" = "showErrors";
        "editor.inlineSuggest.enabled" = true;
        "github.copilot.enable" = {
          "*" = true;
          "plaintext" = true;
          "markdown" = false;
          "scminput" = false;
          "yaml" = false;
        };
        "[python]" = {
          "editor.formatOnType" = true;
        };
        "settingsSync.ignoredExtensions" = [];
        "workbench.colorTheme" = "Nord";
        "editor.fontFamily" = "'Fira Code', 'Font Awesome 5', 'Font Awesome 5 Free Regular', 'Font Awesome 5 Free Solid', 'Font Awesome 5 Brands Regular', 'FiraCode Nerd Font Mono', CaskaydiaCoveNerdFont, 'Droid Sans Mono', 'monospace', monospace";
        "[helm]" = {
          "editor.formatOnSave" = false;
        };
        "redhat.telemetry.enabled" = false;
        "editor.fontLigatures" = true;
      };
      extensions = with pkgs; [
        vscode-extensions.bbenoist.nix
        vscode-extensions.arcticicestudio.nord-visual-studio-code
        vscode-extensions.dbaeumer.vscode-eslint
      ];
    };

    programs.git = {
      enable = true;
      userName  = "lanath";
      userEmail = "valentin.vivier@bhc-it.com";
      signing = {
        signByDefault = true;
        key = "5089810F35CD9FEBB76E1FEF6B8C16D2CDC8CA93";
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

    home.file.".wallpapers/wallpaper.png" = {
      source = ./nord-city.jpeg;
    };
  };
}
