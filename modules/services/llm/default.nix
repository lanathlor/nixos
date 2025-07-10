{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    package = pkgs.ollama-rocm;
    environmentVariables = {
      HIP_VISIBLE_DEVICES = "0";
      ROCR_VISIBLE_DEVICES = "0";
      LD_LIBRARY_PATH = "/run/opengl-driver/lib:/run/opengl-driver-32/lib";
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

  services.open-webui = {
    enable = true;
    port = 18080;
  };
}
