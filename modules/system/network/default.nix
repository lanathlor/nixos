{ lib, pkgs, ... }:
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
      "2.13.105.165" = [ "master.monkey" "*.master.monkey" ];
      "127.0.0.1" = [ "dex" "keycloak" ];
    };
  };
}
