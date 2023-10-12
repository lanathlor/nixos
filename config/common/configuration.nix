{ config, pkgs, lib, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";
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
    themePackages = [(pkgs.adi1090x-plymouth-themes.override {selected_themes = ["hexagon_hud"];})];
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  system.autoUpgrade.enable = true;
  system.stateVersion = "23.05";

  nixpkgs.config.allowUnfree = true;
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
    useDHCP = lib.mkDefault false;
    nameservers = lib.mkDefault [ "1.1.1.1" "8.8.8.8" ];
  };

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

  programs.ssh.startAgent = true;

  programs.hyprland.enable = true;

  programs.gnupg.agent.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.rtkit.enable = true;
  security.pam.services.swaylock = {};
  security.pam.services.sddm.enableKwallet = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  security.pam.services.login.enableKwallet = true;
  security.polkit.enable = true;

  services.xserver.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  sound.enable = true;


  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  services.mullvad-vpn.enable = true;

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  services.blueman.enable = true;

  services.xserver = {
    layout = lib.mkDefault "us";
    xkbVariant = "";
  };

  services.xserver.displayManager.sddm = {
    enable = true;
    autoNumlock = true;
  };

  systemd.targets.time-sync.wantedBy = [ "multi-user.target" ];


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

    # utils
    htop

    # maintenance
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
  ];

  fonts.fonts = with pkgs; [
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
    proggyfonts
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  fonts.fontDir.enable = true;

  fonts = {
    enableDefaultFonts = true;

    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Sans Mono" "FiraCode Nerd Font Mono" ];
        sansSerif = [ "Noto Sans Mono" "FiraCode Nerd Font Mono" ];
        monospace = [ "Noto Sans Mono" "FiraCode Nerd Font Mono" ];
      };
    };
  };


  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
    };
  };

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      dns = [
        "8.8.8.8"
        "8.8.4.4"
      ];
    };
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

}