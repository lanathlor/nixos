# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, lib, ... }:
{
  imports = [
    ./lanath-desktop-hardware-configuration.nix

    ../modules/services/llm

    ../modules/system
    ../modules/system/user/lanath.nix
    ../modules/system/user/mushu.nix
    ../modules/system/virt/docker.nix
    ../modules/system/virt/kubernetes.nix
    ../modules/system/virt/qemu.nix

    ../modules/games
    ../modules/nix

    ../modules/rice
    ../modules/rice/de/hyprland.nix
    ../modules/rice/theme/nordic

    ../modules/services/ssh
    ../modules/services/traefik
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

  # Enable games
  modules.games.warcraftlogs.enable = true;
  modules.games.wago-addons.enable = true;

  systemd.targets.time-sync.wantedBy = [ "multi-user.target" ];

  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "switch-to-headless" ''
      exec sudo /run/current-system/specialisation/headless/bin/switch-to-configuration switch
    '')
    (writeShellScriptBin "switch-to-desktop" ''
      exec sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
    '')
  ];

  specialisation = {
    headless.configuration = {
      services.xserver.enable = lib.mkForce false;
      services.displayManager.gdm.enable = lib.mkForce false;
      programs.hyprland.enable = lib.mkForce false;
      services.ollama.enable = lib.mkForce false;
    };
  };
}
