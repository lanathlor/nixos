{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  networking = {
    nat = {
      enable = true;
      externalInterface = "wlo1";
      internalInterfaces = [ "wg0" ];
    };

    firewall = {
      allowedUDPPorts = [ 51820 ];
    };
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.0.10.0/24" ];

      listenPort = 51820;

      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.0.10.0/24 -o wlo1 -j MASQUERADE
      '';

      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.10.0/24 -o wlo1 -j MASQUERADE
      '';

      privateKeyFile = "/home/saga/wireguard-keys/private";

      peers = [
        {
          publicKey = "hO+DjlTJItqM8JeUIQ6q2zwYMqLS122sKPNCK2Hom10=";
          allowedIPs = [ "10.0.0.0/24" ];
        }
      ];
    };
  };
}