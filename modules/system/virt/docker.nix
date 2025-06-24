{ ... }:
{
  virtualisation.docker = {
    enable = true;
    daemon.settings = { };
    rootless = {
      enable = false;
      setSocketVariable = true;
    };
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };
  # virtualisation.podman = {
  #   enable = true;
  #   dockerCompat = true;
  #   dockerSocket = {
  #     enable = true;
  #   };
  # };
}
