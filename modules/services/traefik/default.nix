{ ... }:
{
  # Traefik reverse proxy — HTTP only, Docker provider
  services.traefik = {
    enable = true;
    group = "docker";

    staticConfigOptions = {
      entryPoints.web.address = ":80";

      providers.docker = {
        endpoint = "unix:///var/run/docker.sock";
        exposedByDefault = false;
        network = "traefik-net";
      };

      api.dashboard = true;
    };

    dynamicConfigOptions = {
      http = {
        routers.dashboard = {
          rule = "Host(`traefik.local.dosismart.com`)";
          service = "api@internal";
          entryPoints = [ "web" ];
        };
      };
    };
  };

  # Create traefik-net Docker network before Traefik starts
  systemd.services.traefik-net = {
    description = "Create traefik-net Docker network";
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "/bin/sh -c '/run/current-system/sw/bin/docker network create traefik-net || true'";
    };
  };

  systemd.services.traefik = {
    after = [ "traefik-net.service" ];
    requires = [ "traefik-net.service" ];
  };

  # Allow HTTP traffic
  networking.firewall.allowedTCPPorts = [ 80 ];
}
