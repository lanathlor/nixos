{ pkgs, lib, pkgs-unstable, ... }:
let
  tmuxTestMonitor = pkgs.writeShellScript "tmux-test-monitor" ''
    TMUX="${pkgs.tmux}/bin/tmux"
    GREP="${pkgs.gnugrep}/bin/grep"
    TAIL="${pkgs.coreutils}/bin/tail"
    SLEEP="${pkgs.coreutils}/bin/sleep"

    while true; do
      if ! $TMUX info &>/dev/null 2>&1; then
        $SLEEP 5
        continue
      fi

      declare -A win_fail
      declare -A win_pass

      while IFS=' ' read -r pane_id win_target; do
        [[ -z "$pane_id" || -z "$win_target" ]] && continue
        content=$($TMUX capture-pane -p -t "$pane_id" -J 2>/dev/null | $TAIL -n 80)
        if echo "$content" | $GREP -qE "FAIL[[:space:]]|[0-9]+ failed|[×✗]"; then
          win_fail[$win_target]=1
        elif echo "$content" | $GREP -qE "PASS[[:space:]]|[0-9]+ passed|[✓✔]"; then
          win_pass[$win_target]=1
        fi
      done < <($TMUX list-panes -a -F "#{pane_id} #{session_name}:#{window_index}" 2>/dev/null)

      while IFS= read -r win; do
        if [[ "''${win_fail[$win]:-}" == "1" ]]; then
          $TMUX set-option -wt "$win" @test_status fail 2>/dev/null
        elif [[ "''${win_pass[$win]:-}" == "1" ]]; then
          $TMUX set-option -wt "$win" @test_status pass 2>/dev/null
        else
          $TMUX set-option -uwt "$win" @test_status 2>/dev/null
        fi
      done < <($TMUX list-windows -a -F "#{session_name}:#{window_index}" 2>/dev/null)

      unset win_fail win_pass
      $SLEEP 2
    done
  '';
in
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
      package = pkgs.nerd-fonts.fira-code;
      name = "FiraCode Nerd Font Mono";
      size = 11;
    };
    settings = lib.mkDefault {
      enable_audio_bell = false;
      update_check_interval = 0;
      allow_remote_control = "socket-only";
      listen_on            = "unix:/tmp/kitty-{kitty_pid}";
    };
  };

  programs.neovim = {
    enable = true;
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    historyLimit = 50000;
    plugins = with pkgs.tmuxPlugins; [
      resurrect
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '15'
        '';
      }
    ];
    extraConfig = ''
      # True-color and UTF-8 support (needed for powerline glyphs)
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-kitty:Tc,xterm-256color:Tc"

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

  # Run dunst directly — config managed by theme-switch (not home-manager)
  systemd.user.services.dunst = {
    Unit = {
      Description = "Dunst notification daemon";
      PartOf = [ "graphical-session.target" ];
      After  = [ "graphical-session.target" ];
    };
    Service = {
      Type        = "dbus";
      BusName     = "org.freedesktop.Notifications";
      ExecStart   = "${pkgs.dunst}/bin/dunst";
      Restart     = "on-failure";
      RestartSec  = "1s";
    };
    Install = { WantedBy = [ "graphical-session.target" ]; };
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
      keybinding = {
        universal = {
          undo = "<c-z>";  # VSCode-style undo
        };
      };
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
    enableSshSupport = true;
    grabKeyboardAndMouse = false;
    pinentry.package = pkgs.pinentry-curses;
    extraConfig = ''
      allow-loopback-pinentry
    '';
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    gcc
    gnupg
    dunst
  ];
  home.sessionVariables.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
    pkgs.gcc.cc.lib
  ];

  systemd.user.services.tmux-test-monitor = {
    Unit = {
      Description = "Monitor tmux panes for test runner pass/fail status";
      After = [ "default.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${tmuxTestMonitor}";
      Restart = "on-failure";
      RestartSec = "5s";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
