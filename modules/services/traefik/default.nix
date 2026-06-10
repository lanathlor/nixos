{ pkgs, localConfig, ... }:
let
  domain = localConfig.localDomain;
in
{
  # Traefik reverse proxy — HTTPS with mkcert wildcard cert, Docker provider

  environment.systemPackages = [ pkgs.mkcert pkgs.nss.tools ];


  # Generate local CA + wildcard cert on activation
  system.activationScripts.traefik-certs = {
    text = ''
      CAROOT=/var/lib/mkcert
      CERT_DIR=/var/lib/traefik-certs

      mkdir -p "$CAROOT" "$CERT_DIR"

      if [ ! -f "$CAROOT/rootCA.pem" ]; then
        CAROOT="$CAROOT" ${pkgs.mkcert}/bin/mkcert -install 2>/dev/null || true
      fi

      if [ ! -f "$CERT_DIR/${domain}.pem" ]; then
        CAROOT="$CAROOT" ${pkgs.mkcert}/bin/mkcert \
          -cert-file "$CERT_DIR/${domain}.pem" \
          -key-file  "$CERT_DIR/${domain}-key.pem" \
          "*.${domain}" "${domain}"
      fi

      chown -R traefik:traefik "$CERT_DIR" 2>/dev/null || true
      chmod 640 "$CERT_DIR/"*.pem 2>/dev/null || true

      # Install CA into system NSS store so browsers with ImportEnterpriseRoots trust it
      CAROOT="$CAROOT" ${pkgs.mkcert}/bin/mkcert -install 2>/dev/null || true
    '';
    deps = [];
  };

  services.traefik = {
    enable = true;
    group = "docker";

    staticConfigOptions = {
      entryPoints.web = {
        address = ":80";
        http.redirections.entryPoint = {
          to = "websecure";
          scheme = "https";
          permanent = false;
        };
      };
      entryPoints.websecure.address = ":443";

      providers.docker = {
        endpoint = "unix:///var/run/docker.sock";
        exposedByDefault = false;
        network = "traefik-net";
      };

      api.dashboard = true;
    };

    dynamicConfigOptions = {
      tls.stores.default.defaultCertificate = {
        certFile = "/var/lib/traefik-certs/${domain}.pem";
        keyFile  = "/var/lib/traefik-certs/${domain}-key.pem";
      };

      http = {
        routers.dashboard = {
          rule = "Host(`traefik.${domain}`)";
          service = "api@internal";
          entryPoints = [ "websecure" ];
          tls = {};
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

  # Allow HTTP and HTTPS traffic
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
