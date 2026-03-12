# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ ... }:
{
  imports = [
    ./mushu-desktop-hardware-configuration.nix

    ../modules/services/llm

    ../modules/system
    ../modules/system/user/lanath.nix
    ../modules/system/user/mushu.nix
    ../modules/system/virt/docker.nix
    ../modules/system/virt/kubernetes.nix

    ../modules/games
    ../modules/nix

    ../modules/rice
    ../modules/rice/de/hyprland.nix
    ../modules/rice/de/gnome.nix
    ../modules/rice/theme/nordic

    ../modules/services/ssh
    ../modules/services/traefik
  ];

  environment.sessionVariables.NIX_CONFIG_USER = "mushu-desktop";
  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "1";

  networking.hostName = "mushu-desktop";

  modules.games.warcraftlogs.enable = true;
  modules.games.wago-addons.enable = true;

  systemd.targets.time-sync.wantedBy = [ "multi-user.target" ];
}
