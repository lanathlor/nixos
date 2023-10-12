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
      ../../home/lanath-laptop/home.nix
      (import "${home-manager}/nixos")
      nur-no-pkgs.repos.LuisChDev.modules.nordvpn
    ];

  # Bootloader.

  boot.plymouth = {
    theme = "hexagon_hud";
  };

  environment.sessionVariables.NIX_CONFIG_USER = "lanath-laptop";
  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "1";
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";


  networking.hostName = "laptop";

  services.xserver.displayManager.sddm = {
    theme = "Nordic/Nordic";
  };

  users.users.lanath = {
    isNormalUser = true;
    description = "lanath";
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" "storage" ];
    initialHashedPassword = "$y$j9T$TFdhvKQ4clM.JxX1ScPkq1$tOxZv2DOIBWF/uhoyfCbzIkCYZuwa9BfEPNI4wmzqN3";
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

    docker-compose

    # sddm modules
    libsForQt5.plasma-framework
    libsForQt5.plasma-workspace
    libsForQt5.qt5.qtgraphicaleffects

    # gui
    thunderbird
    pavucontrol
    qbittorrent
    etcher
  ];

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-12.2.3"
  ];
}
