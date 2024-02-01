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
      ../../home/mushu-laptop/home.nix
    ];

  # Bootloader.

  boot.plymouth = {
    theme = "hexagon_hud";
  };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # nix.nixPath = [
  #   "nixos-config=/home/mushu/my-config/config/mushu-laptop/configuration.nix"
  # ];
  environment.sessionVariables.NIX_CONFIG_USER = "mushu-laptop";
  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "1";


  networking.hostName = "mushu";

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  ];

  services.xserver.displayManager.sddm = {
    theme = "Nordic/Nordic";
  };

  users.users.mushu = {
    isNormalUser = true;
    description = "mushu";
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" "storage" ];
    initialHashedPassword = "$y$j9T$VrPz1k/jk19bM88S5gkl21$o8EsCXEltY8YmLrpfRnV078I2VM4/Nkq.zk219avNaB";
    openssh.authorizedKeys.keyFiles = [ ./id_rsa.pub ];
    packages = with pkgs; [
    ];
  };

  services.xserver = {
    layout = "fr";
    xkbVariant = "azerty";
  };
  i18n.consoleKeyMap = "fr";
  console.keyMap = "fr";

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

  hardware.bluetooth.enable = false;

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
    etcher
    teams-for-linux
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-19.1.9"
    "electron-12.2.3"
    "teams-1.5.00.23861"
  ];

  security.pki.certificateFiles = [
    "/home/mushu/.cert/self-signed/certificate.pem"
    ./certificate.pem
    ./kube-cert.pem
    ./node.pem
  ];

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.sddm.enable = lib.mkForce false;
  xdg.portal.enable = lib.mkForce false;

  programs.hyprland.enable = lib.mkForce false;

  services = {
    pipewire = {
      enable = lib.mkForce false;
    };
  };
}
