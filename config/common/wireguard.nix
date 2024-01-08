{ ... }:
{

  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.2/24" ];
      listenPort = 51820;

      privateKeyFile = "/etc/wireguard/keys/private";

      peers = [
        {
          publicKey = "l9JcvsK0uo2+PR0lm0EVDDWtsObKEQOajbW9ViZOKAw=";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "charon.master.monkey:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
