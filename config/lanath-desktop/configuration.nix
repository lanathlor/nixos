# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixos-unstable)
    # reuse the current configuration
    { config = config.nixpkgs.config; };
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ../common/configuration.nix
      ./hardware-configuration.nix
      ../common/terms.nix
      ../../home/lanath-desktop/home.nix
    ];

  # Bootloader.

  boot.plymouth = {
    theme = "hexagon_hud";
  };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # nix.nixPath = [
  #   "nixos-config=/home/lanath/my-config/config/lanath-desktop/configuration.nix"
  # ];
  environment.sessionVariables.NIX_CONFIG_USER = "lanath-desktop";
  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "1";


  networking.hostName = "desktop";

  #networking.enableIPv6  = false;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-run"
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  hardware.opengl.driSupport32Bit = true;

  # services.displayManager.sddm = {
  #   theme = "Nordic/Nordic";
  # };

  users.extraGroups.vboxusers.members = [ "lanath" ];

  users.users.lanath = {
    isNormalUser = true;
    description = "lanath";
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" "storage" ];
    initialHashedPassword = "$y$j9T$TFdhvKQ4clM.JxX1ScPkq1$tOxZv2DOIBWF/uhoyfCbzIkCYZuwa9BfEPNI4wmzqN3";
    openssh.authorizedKeys.keyFiles = [ ../../keys/lanath.pub ];
    packages = with pkgs; [
    ];
  };

  users.users.mushu = {
    isNormalUser = true;
    description = "mushu";
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" "storage" ];
    initialHashedPassword = "$y$j9T$TFdhvKQ4clM.JxX1ScPkq1$tOxZv2DOIBWF/uhoyfCbzIkCYZuwa9BfEPNI4wmzqN3";
    openssh.authorizedKeys.keyFiles = [ ../../keys/mushu.pub ];
    packages = with pkgs; [
    ];
  };

  services.prometheus.exporters = {
    node = {
      enable = true;
      enabledCollectors = [
        "conntrack"
        "diskstats"
        "entropy"
        "filefd"
        "filesystem"
        "loadavg"
        "mdadm"
        "meminfo"
        "netdev"
        "netstat"
        "stat"
        "time"
        "vmstat"
        "systemd"
        "logind"
        "interrupts"
        "ksmd"
        "processes"
      ];
    };
  };

  environment.systemPackages = with pkgs; [

    nordic
    nordic.sddm

    # browsers
    firefox-wayland
    google-chrome
    chromium
    tor

    # utils
    bluez
    brightnessctl

    docker-compose
    kubectl

    # sddm modules
    libsForQt5.plasma-framework
    libsForQt5.plasma-workspace
    libsForQt5.qt5.qtgraphicaleffects

    # gui
    thunderbird
    pavucontrol
    teams-for-linux

    tcpreplay
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-19.1.9"
    "electron-12.2.3"
    "teams-1.5.00.23861"
    "nix-2.15.3"
    "qbittorrent-4.6.4"
  ];

  # security.pki.certificateFiles = [
  #   "/home/lanath/.cert/self-signed/certificate.pem"
  #   ./certificate.pem
  #   ./kube-cert.pem
  #   ./node.pem
  # ];
}
