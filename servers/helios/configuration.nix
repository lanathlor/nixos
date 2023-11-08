{ config, pkgs, lib, ... }:
{

  imports = [
    ./hardware-configuration.nix
    ../common/config.nix
  ];

  environment.etc."helios".source = builtins.fetchGit {
    url = "https://github.com/lanathlor/nixos";
  };

  environment.sessionVariables.NIX_CONFIG_USER = "helios";
  networking.hostName = "helios";

  environment.systemPackages = with pkgs; [
  ];

  users.users.helios = {
    isNormalUser = true;
    description = "helios";
    extraGroups = [  ];
    openssh.authorizedKeys.keyFiles = [ ./lanath.pub ];
    packages = with pkgs; [
    ];
  };
}
