{ pkgs, pkgs-unstable, ... }:
{
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    package = pkgs-unstable.ollama-rocm;
    environmentVariables = {
      HIP_VISIBLE_DEVICES = "0";
      ROCR_VISIBLE_DEVICES = "0";
      LD_LIBRARY_PATH = "/run/opengl-driver/lib:/run/opengl-driver-32/lib";
      OLLAMA_NUM_CTX = "131072";
    };
    user = "ollama";
    group = "ollama";
  };

  # Create ollama user and add to necessary groups
  users.users.ollama = {
    isSystemUser = true;
    group = "ollama";
    extraGroups = [ "video" "render" ];
  };
  users.groups.ollama = { };

  # Ensure proper permissions for ROCm devices
  services.udev.extraRules = ''
    KERNEL=="kfd", GROUP="render", MODE="0666"
    KERNEL=="renderD*", GROUP="render", MODE="0666"
  '';

  # open-webui NixOS package broken in 25.11 (npm prefetch HTTP/2 bug)
  # Run via Docker: docker run -d -p 18080:8080 ghcr.io/open-webui/open-webui:main
}
