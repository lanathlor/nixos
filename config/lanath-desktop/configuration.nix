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
      ../../home/lanath-desktop/home.nix
      nur-no-pkgs.repos.LuisChDev.modules.nordvpn

      # bind tests
    ];

  # Bootloader.

  boot.plymouth = {
    theme = "hexagon_hud";
  };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  boot.kernel.sysctl = {
    "net.ipv4.ip_unprivileged_port_start" = 443;
  };

  # nix.nixPath = [
  #   "nixos-config=/home/lanath/my-config/config/lanath-desktop/configuration.nix"
  # ];
  environment.sessionVariables.NIX_CONFIG_USER = "lanath-desktop";
  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "1";
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";


  networking.hostName = "desktop";

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
    teams-for-linux
  ];

  fonts.fonts = with pkgs; [
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-12.2.3"
    "teams-1.5.00.23861"
  ];


  # networking.wlanInterfaces = {
  #   "wlan-station0" = { device = "wlp25s0";                            };
  #   "wlan-ap0"      = { device = "wlp25s0"; mac = "08:11:96:0e:08:0a"; };
  # };

  # networking.networkmanager.unmanaged = [ "interface-name:wlp*" ]
  #   ++ lib.optional config.services.hostapd.enable "interface-name:${config.services.hostapd.interface}";

  # services.hostapd = {
  #   enable        = true;
  #   interface     = "wlan-ap0";
  #   hwMode        = "g";
  #   ssid          = "nix";
  #   wpaPassphrase = "mysekret";
  # };

  # networking.interfaces."wlan-ap0".ipv4.addresses =
  #   lib.optionals config.services.hostapd.enable [{ address = "192.168.12.1"; prefixLength = 24; }];

  # services.dnsmasq = lib.optionalAttrs config.services.hostapd.enable {
  #   enable = true;
  #   extraConfig = ''
  #     interface=wlan-ap0
  #     bind-interfaces
  #     dhcp-range=192.168.12.10,192.168.12.254,24h
  #   '';
  # };
  # services.haveged.enable = config.services.hostapd.enable;
}
