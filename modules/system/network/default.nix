{ lib, pkgs, localConfig, ... }:
{
  services.resolved.enable = false;

  networking = {
    hostName = lib.mkDefault "nixos";
    networkmanager = lib.mkDefault {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openvpn
        networkmanager-openconnect
      ];
    };

    firewall.checkReversePath = lib.mkDefault false;
    firewall.enable = false;
    useDHCP = lib.mkDefault true;
    # nameservers = [ "10.1.0.1" "1.1.1.1" "8.8.8.8" ];
    hosts = {
      "127.0.0.1" = [ "dex" "keycloak" ];
    } // localConfig.extraHosts;
  };
}
