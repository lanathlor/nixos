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
      # Copy selection to system clipboard (Wayland)
      bind -T copy-mode MouseDragEnd1Pane send -X copy-pipe-and-cancel "${pkgs.wl-clipboard}/bin/wl-copy"
      bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-and-cancel "${pkgs.wl-clipboard}/bin/wl-copy"

      # Intuitive splits (open in current directory)
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # New window keeps current directory
      bind c new-window -c "#{pane_current_path}"

      # Status bar styling
      set -g window-status-current-style "bg=blue,fg=white,bold"
      set -g window-status-current-format " #I:#W "
      set -g window-status-format " #I:#W "
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
