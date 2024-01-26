# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixos-unstable)
    # reuse the current configuration
    { config = config.nixpkgs.config; };
  nur-no-pkgs = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") { };
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ../common/configuration.nix
      ./hardware-configuration.nix
      ../common/terms.nix
      ../../home/lanath-laptop/home.nix
    ];

  # Bootloader.

  boot.plymouth = {
    theme = "hexagon_hud";
  };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.sessionVariables.NIX_CONFIG_USER = "lanath-laptop";
  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "1";


  networking.hostName = "laptop";

  services.xserver.displayManager.sddm = {
    theme = "Nordic/Nordic";
  };

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "lanath" ];

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
    nordic.sddm

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

  nixpkgs.config.permittedInsecurePackages = [
    "electron-19.1.9"
    "electron-12.2.3"
  ];

  security.pki.certificateFiles = [
    "/home/lanath/.cert/self-signed/certificate.pem"
    ./certificate.pem
    ./kube-cert.pem
  ];


}
