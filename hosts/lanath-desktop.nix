# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, ... }:
let
  unstable = import
    (builtins.fetchTarball "https://github.com/nixos/nixpkgs/tarball/nixos-unstable")
    { config = config.nixpkgs.config; };
in
{
  imports = [
    ./hardware-configuration.nix

    ../modules/system
    ../modules/system/user/lanath.nix
    ../modules/system/user/mushu.nix
    ../modules/system/virt/docker.nix
    ../modules/system/virt/kubernetes.nix

    ../modules/games
    ../modules/nix

    ../modules/rice
    ../modules/rice/lanath.nix
    ../modules/rice/mushu.nix

    ../modules/services/ssh
  ];

  environment.sessionVariables.NIX_CONFIG_USER = "lanath-desktop";
  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "1";

  networking.hostName = "desktop";

  systemd.targets.time-sync.wantedBy = [ "multi-user.target" ];

  home-manager.users.lanath = { pkgs, ... }: {
    imports = [
      ../modules/devel/vscode/lanath.nix
    ];

    home.packages = [
      unstable.discord
      unstable.dorion
    ];

    programs.home-manager.enable = true;

    nixpkgs = {
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
      };
    };

    home.stateVersion = "25.05";
  };

  home-manager.users.mushu = { pkgs, ... }: {
    imports = [
      ../modules/devel/vscode/lanath.nix
    ];

    home.packages = [
      unstable.discord
      unstable.dorion
    ];

    programs.home-manager.enable = true;

    nixpkgs = {
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
      };
    };

    home.stateVersion = "25.05";
  };
}
