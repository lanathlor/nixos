{ config, pkgs, lib, ... }:
{

  imports = [
    ./hardware-configuration.nix
    ../utils/bind/bindConfig.nix
    ../common/config.nix
  ];

  environment.etc."styx".source = builtins.fetchGit {
    url = "https://github.com/lanathlor/nixos";
  };

  environment.sessionVariables.NIX_CONFIG_USER = "styx";
  networking.hostName = "styx";

  environment.systemPackages = with pkgs; [
  ];

  users.users.styx = {
    isNormalUser = true;
    description = "styx";
    extraGroups = [  ];
    openssh.authorizedKeys.keyFiles = [ ./lanath.pub ];
    packages = with pkgs; [
    ];
  };
}
