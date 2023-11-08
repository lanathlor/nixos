
{... }:
{
  services.bind = {
    enable = true;
    zones = {
      "bhc-it.internal" = {
        file = ./bhc-it.internal;
        master = true;
      };
      "master.monkey" = {
        file = ./master.monkey;
        master = true;
      };
    };
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };
}