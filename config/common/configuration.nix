{ config, pkgs, lib, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixos-unstable)
    # reuse the current configuration
    { config = config.nixpkgs.config; };
in
{

  imports = [
    (import "${home-manager}/nixos")
  ];

  boot.loader.grub = {
    enable = true;
    useOSProber = true;
    efiSupport = true;
    devices = [ "nodev" ];
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth = {
    enable = true;
    themePackages = [ (pkgs.adi1090x-plymouth-themes.override { selected_themes = [ "hexagon_hud" ]; }) ];
  };

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      trusted-users = [ "lanath" "root" ];
      substituters = [
        "https://ai.cachix.org"
        "https://cache.nixos.org/"
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };

  system.stateVersion = "24.11";

  nixpkgs.config.allowUnfree = true;
  environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";

  nixpkgs.config.packageOverrides = pkgs: rec {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  networking = {
    hostName = lib.mkDefault "nixos";
    networkmanager = lib.mkDefault {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openvpn
        networkmanager-openconnect
      ];
    };

    firewall.checkReversePath = lib.mkDefault false;
    firewall.enable = lib.mkDefault false;
    useDHCP = lib.mkDefault true;
    # nameservers = [ "10.1.0.1" "1.1.1.1" "8.8.8.8" ];
    hosts = {
      "2.13.105.165" = [ "master.monkey" "*.master.monkey" ];
      "127.0.0.1" = [ "dex" "keycloak" ];
    };
  };

  services.resolved.enable = false;

  time.timeZone = lib.mkDefault "Europe/Paris";

  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = lib.mkDefault "en_GB.UTF-8";
    LC_IDENTIFICATION = lib.mkDefault "en_GB.UTF-8";
    LC_MEASUREMENT = lib.mkDefault "en_GB.UTF-8";
    LC_MONETARY = lib.mkDefault "en_GB.UTF-8";
    LC_NAME = lib.mkDefault "en_GB.UTF-8";
    LC_NUMERIC = lib.mkDefault "en_GB.UTF-8";
    LC_PAPER = lib.mkDefault "en_GB.UTF-8";
    LC_TELEPHONE = lib.mkDefault "en_GB.UTF-8";
    LC_TIME = lib.mkDefault "en_GB.UTF-8";
  };

  programs.thunar.enable = true;

  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  programs.file-roller.enable = true;

  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
    askPassword = "${pkgs.lxqt.lxqt-openssh-askpass}/bin/lxqt-openssh-askpass";
  };

  programs.hyprland.enable = true;

  programs.gnupg.agent.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.pam.services.swaylock = { };
  security.pam.services.sddm.enableKwallet = true;
  security.pam.services.login.enableKwallet = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
  };

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  # nixpkgs.config.pulseaudio = true;
  # hardware.pulseaudio.enable = true;
  # hardware.pulseaudio.support32Bit = true;

  services.mullvad-vpn.enable = true;

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  services.blueman.enable = true;

  services.xserver = {
    enable = true;
    xkb = {
      layout = lib.mkDefault "us";
      variant = "";
    };
    displayManager.gdm = {
      wayland = true;
      #};
      #displayManager.sddm = {
      enable = true;
      #autoNumlock = true;
      #wayland.enable = true;
      settings.General.DisplayServer = "x11-user";
    };
  };

  environment.systemPackages = with pkgs; [
    # ide
    vim

    # terms
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fishPlugins.autopair
    fishPlugins.bass
    fzf
    fishPlugins.grc
    grc
    fishPlugins.z

    # dev
    git
    nixpkgs-fmt

    # utils
    htop
    lxqt.lxqt-openssh-askpass
    ssh-askpass-fullscreen
    nixfmt-rfc-style
    openvpn
    wireguard-tools
    mattermost-desktop
    tig
    kubernetes-helm
    nil

    # maintenance
    zip
    unzip
    lshw
    xorg.xhost
    libva-utils
    acpi
    fd
    sptk
    bat
    jq
    ripgrep
    yq
    killall
    lm_sensors
    s-tui
    dig
    ldm
    pixcat
    arp-scan
    busybox
    nmap
    nftables
    iptables
    ethtool
    wireshark


    qemu

    # game
    wineWowPackages.stable
    wine
    (wine.override { wineBuild = "wine64"; })
    wine64
    wineWowPackages.staging
    winetricks
    wineWowPackages.waylandFull
    (wineWowPackages.full.override {
      wineRelease = "staging";
      mingwSupport = true;
    })
    wowup-cf
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    font-awesome
    font-awesome_5
    proggyfonts
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  fonts.fontDir.enable = true;

  fonts = {
    enableDefaultPackages = true;

    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Sans Mono" "FiraCode Nerd Font Mono" ];
        sansSerif = [ "Noto Sans Mono" "FiraCode Nerd Font Mono" ];
        monospace = [ "Noto Sans Mono" "FiraCode Nerd Font Mono" ];
      };
    };
  };


  # systemd = {
  #   user.services.polkit-gnome-authentication-agent-1 = {
  #     description = "polkit-gnome-authentication-agent-1";
  #     wantedBy = [ "graphical-session.target" ];
  #     wants = [ "graphical-session.target" ];
  #     after = [ "graphical-session.target" ];
  #     serviceConfig = {
  #       Type = "simple";
  #       ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  #       Restart = "on-failure";
  #       RestartSec = 1;
  #       TimeoutStopSec = 10;
  #     };
  #   };
  # };

  systemd.targets.time-sync.wantedBy = [ "multi-user.target" ];


  virtualisation.docker = {
    enable = true;
    daemon.settings = { };
    rootless = {
      enable = false;
      setSocketVariable = true;
    };
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };
}
