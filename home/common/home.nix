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
  impermanence = builtins.fetchTarball "https://github.com/nix-community/impermanence/archive/master.tar.gz";
in
{
  imports = [
    hyprland.homeManagerModules.default
    "${impermanence}/home-manager.nix"
  ];

  home.stateVersion = "23.05";

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    swww
    dmenu
    playerctl
    networkmanagerapplet
    xfce.orage
    baobab
    keepassxc
    gparted
    grim
    slurp
    wl-clipboard
    cliphist
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    font-awesome
    font-awesome_5
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
  };


  programs.waybar = {
    enable = true;
    package = lib.mkDefault unstable.waybar;
    systemd = lib.mkDefault {
       enable = true;
       target = "basic.target";
    };
  };

  programs.fish = {
    enable = true;
  };

  programs.kitty = {
    enable = true;
    keybindings = lib.mkDefault {
      "ctrl+c" = "copy_or_interrupt";
      "ctrl+v" = "paste_from_clipboard";
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

  programs.git = {
    enable = true;
  };

  programs.swaylock = {
    enable = true;
  };

  programs.btop = {
    enable = true;
    settings = lib.mkDefault {
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
  };

  programs.mpv = {
    enable = true;
    config = lib.mkDefault {
      profile = "gpu-hq";
      force-window = true;
      ytdl-format = "bestvideo+bestaudio";
      cache-default = 4000000;
    };
    scripts = with unstable.mpvScripts; lib.mkDefault [ mpris sponsorblock mpv-playlistmanager quality-menu thumbfast ];
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

  services.mpd = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  xdg.userDirs.enable = true;

  gtk = {
    enable = true;
  };

  fonts.fontconfig.enable = true;

  xdg.mimeApps.enable = true;

  home.file."Document/.keep".source = builtins.toFile "keep" "";
  home.file."Downloads/.keep".source = builtins.toFile "keep" "";
  home.file."Music/.keep".source = builtins.toFile "keep" "";
  home.file."Work/.keep".source = builtins.toFile "keep" "";
  home.file."Dotfiles".source = builtins.fetchGit {
    url = "https://github.com/lanathlor/nixos";
  };

}
