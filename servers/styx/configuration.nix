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

  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /shared_storage         10.0.1.1(rw,fsid=0,no_subtree_check) 10.0.2.1(rw,fsid=0,no_subtree_check)
    /shared_storage/lanath  10.0.1.1(rw,sync,nohide,insecure,all_squash,no_subtree_check,no_root_squash) 10.0.2.1(rw,nohide,insecure,no_subtree_check)
    /shared_storage/mushu   10.0.1.2(rw,nohide,insecure,no_subtree_check) 10.0.2.2(rw,nohide,insecure,no_subtree_check)
  '';
  networking.firewall.allowedTCPPorts = [ 2049 ];
}
