# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
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
      ../common/terms.nix
      ../../home/imsike-desktop/home.nix
      nur-no-pkgs.repos.LuisChDev.modules.nordvpn
    ];

  # Bootloader.

  boot.plymouth = {
    theme = "hexagon_hud";
  };

  environment.sessionVariables.NIX_CONFIG_USER = "imsike-desktop";
  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "1";
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";


  networking.hostName = "desktop";

  i18n.defaultLocale = "fr_FR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ALL="fr_FR.UTF-8";
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  services.xserver.displayManager.sddm = {
    theme = "Nordic/Nordic";
  };

  users.users.imsike = {
    isNormalUser = true;
    description = "imsike";
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" "storage" ];
    initialHashedPassword = "$6$KZaSYVev$bulibbTCC0axwdOGHNkaoRFFAS6RaNHoTIlLw3S90J9kzNseWHI1XUGN.sJKw4Yv5wYK/p9qzQTCt0TKdF3on/";
    openssh.authorizedKeys.keyFiles = [ ./id_rsa.pub ];
    packages = with pkgs; [
    ];
  };

  hardware.bluetooth.enable = true;

  environment.systemPackages = with pkgs; [
    nordic

    # browsers
    firefox-wayland
    google-chrome
    chromium

    # utils
    bluez
    brightnessctl

    # devtools
    docker-compose
    android-udev-rules
    android-studio
    android-tools
    unstable.nodePackages.pnpm

    # tui
    lazygit

    # sddm modules
    libsForQt5.plasma-framework
    libsForQt5.plasma-workspace
    libsForQt5.qt5.qtgraphicaleffects

    # gui
    thunderbird
    pavucontrol
  ];

  fonts.fonts = with pkgs; [
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-12.2.3"
  ];

  services.xserver = {
    layout = "fr";
  };
}
