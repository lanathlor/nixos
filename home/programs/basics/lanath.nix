{ pkgs, lib, pkgs-unstable, ... }:
{
  programs.waybar = {
    enable = true;
    package = lib.mkDefault pkgs-unstable.waybar;
    systemd = lib.mkDefault {
      enable = true;
      target = "basic.target";
    };
  };

  programs.kitty = {
    enable = true;
    keybindings = lib.mkDefault {
      "ctrl+f>2" = "set_font_size 20";
    };
    font = {
      package = pkgs.noto-fonts;
      name = "Noto Sans Mono";
      size = 11;
    };
    settings = lib.mkDefault {
      enable_audio_bell = false;
      update_check_interval = 0;
    };
  };

  programs.neovim = {
    enable = true;
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    historyLimit = 50000;
    extraConfig = ''
      # Vi-style key bindings in copy mode
      set -g mode-keys vi

      # Copy selection to system clipboard (Wayland)
      # Use copy-pipe (not copy-pipe-and-cancel) so selection stays visible after mouse release
      bind -T copy-mode    MouseDragEnd1Pane send -X copy-pipe "${pkgs.wl-clipboard}/bin/wl-copy"
      bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe "${pkgs.wl-clipboard}/bin/wl-copy"
      # y also copies in vi mode
      bind -T copy-mode-vi y send -X copy-pipe "${pkgs.wl-clipboard}/bin/wl-copy"
      # Single click exits copy mode
      bind -T copy-mode    MouseDown1Pane send -X clear-selection
      bind -T copy-mode-vi MouseDown1Pane send -X clear-selection

      # Intuitive splits (open in current directory)
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # New window keeps current directory
      bind c new-window -c "#{pane_current_path}"

      # ── Nord theme ─────────────────────────────────────────────────
      set -g status-style          "bg=#3B4252,fg=#D8DEE9"
      set -g status-left-style     "bg=#4C566A,fg=#ECEFF4,bold"
      set -g status-right-style    "bg=#4C566A,fg=#ECEFF4"
      set -g status-left           " #S "
      set -g status-right          " %H:%M  %d %b "
      set -g status-left-length    20
      set -g status-right-length   30

      set -g window-status-style          "bg=#3B4252,fg=#D8DEE9"
      set -g window-status-current-style  "bg=#88C0D0,fg=#2E3440,bold"
      set -g window-status-format         " #I:#W "
      set -g window-status-current-format " #I:#W "
      set -g window-status-separator      ""

      set -g pane-border-style        "fg=#4C566A"
      set -g pane-active-border-style "fg=#88C0D0"

      set -g message-style     "bg=#4C566A,fg=#D8DEE9"
      set -g message-command-style "bg=#4C566A,fg=#D8DEE9"

      set -g mode-style "bg=#88C0D0,fg=#2E3440"
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      core = {
        askPass = "";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.btop = {
    enable = true;
    settings = lib.mkDefault {
      color_theme = "TTY";
      theme_background = false;
      truecolor = true;
    };
  };

  programs.mpv = {
    enable = true;
    config = lib.mkDefault {
      profile = "gpu-hq";
      force-window = true;
      ytdl-format = "bestvideo+bestaudio";
      cache-default = 4000000;
    };
    scripts = with pkgs-unstable.mpvScripts; lib.mkDefault [ mpris sponsorblock mpv-playlistmanager quality-menu thumbfast ];
  };

  programs.yt-dlp = {
    enable = true;
  };

  services.dunst = {
    enable = true;
  };

  programs.ssh = {
    enable = true;
    extraConfig = "Include ~/.ssh/vscode_hosts";
    matchBlocks."*" = {
      addKeysToAgent = "yes";
      forwardAgent = true;
    };
  };

  programs.lazygit = {
    enable = true;
    settings = lib.mkDefault {
      theme = "dark";
      confirmOnQuit = true;
      confirmOnQuitTimeout = 5;
      confirmOnQuitMessage = "Are you sure you want to quit?";
    };
  };

  services.swayidle = {
    enable = true;
    systemdTarget = "graphical-session.target";
    events = lib.mkDefault [
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock"; }
      { event = "lock"; command = "${pkgs.swaylock}/bin/swaylock -f"; }
    ];
    timeouts = lib.mkDefault [
      {
        timeout = 300;
        command = "${pkgs.swaylock}/bin/swaylock -f";
        resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
      {
        timeout = 330;
        command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
        resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
      {
        timeout = 600;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
  };

  services.playerctld = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 34560000;
    maxCacheTtl = 34560000;
    defaultCacheTtlSsh = 34560000;
    maxCacheTtlSsh = 34560000;
    enableSshSupport = false;
    pinentry.package = pkgs.pinentry-tty;
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    gcc
    gnupg
  ];
  home.sessionVariables.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
    pkgs.gcc.cc.lib
  ];
}
