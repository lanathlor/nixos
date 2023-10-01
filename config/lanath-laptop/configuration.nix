# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixos-unstable)
    # reuse the current configuration
    { config = config.nixpkgs.config; };
  nur-no-pkgs = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {};
in
{
  imports =
    [ # Include the results of the hardware scan.
      ../common/configuration.nix
      ./hardware-configuration.nix
      ../common/nvidia.nix
      ../common/terms.nix
      ../../home/lanath/home.nix
      (import "${home-manager}/nixos")
      nur-no-pkgs.repos.LuisChDev.modules.nordvpn
    ];

  # Bootloader.

  boot.plymouth = {
    enable = true;
    theme = "hexagon_hud";
    themePackages = [(pkgs.adi1090x-plymouth-themes.override {selected_themes = ["hexagon_hud"];})];
  };


  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "1";
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";


  networking.hostName = "laptop";

  services.xserver.displayManager.sddm = {
    enable = true;
    theme = "Nordic/Nordic";
    autoNumlock = true;
  };

  services.gnome.gnome-keyring.enable = true;
  programs.ssh.startAgent = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

  users.users.lanath = {
    isNormalUser = true;
    description = "lanath";
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" "nordvpn" ];
    packages = with pkgs; [
    ];
  };

  environment.systemPackages = with pkgs; [

    nordic

    wgnord

    # browsers
    firefox-wayland
    google-chrome
    chromium

    # utils
    dmenu
    swaylock
    swww
    bluez

    docker-compose

    # sddm modules
    libsForQt5.plasma-framework
    libsForQt5.plasma-workspace
    libsForQt5.qt5.qtgraphicaleffects

    # gui
    keepassxc
    discord
    baobab
    gparted
    thunderbird
    pavucontrol
    qbittorrent
  ];

  fonts.fonts = with pkgs; [
    nerdfonts
  ];


  programs.sway.enable = true;
  security.pam.services.swaylock = {};


  programs.hyprland.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-kde
    ];
  };

  programs.thunar.enable = true;

  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
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


# a08kzqsu
