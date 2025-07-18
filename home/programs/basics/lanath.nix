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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    extraConfig = {
      core = {
        askPass = "${pkgs.lxqt.lxqt-openssh-askpass}/bin/lxqt-openssh-askpass";
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
    forwardAgent = true;
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
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    gcc
  ];
  home.sessionVariables.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
    pkgs.gcc.cc.lib
  ];
}
