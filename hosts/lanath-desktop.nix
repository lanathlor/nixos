# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:
{
  imports = [
    ./lanath-desktop-hardware-configuration.nix

    ../modules/system
    ../modules/system/user/lanath.nix
    ../modules/system/user/mushu.nix
    ../modules/system/virt/docker.nix
    ../modules/system/virt/kubernetes.nix

    ../modules/games
    ../modules/nix

    ../modules/rice
    ../modules/rice/de/hyprland.nix
    ../modules/rice/theme/nordic

    ../modules/services/ssh
  ];

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  hardware.firmware = with pkgs; [
    linux-firmware
  ];

  # boot.kernelPackages = pkgs.linuxPackages_6_12;

  environment.sessionVariables.NIX_CONFIG_USER = "lanath-desktop";
  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "1";

  networking.hostName = "desktop";

  systemd.targets.time-sync.wantedBy = [ "multi-user.target" ];
}
