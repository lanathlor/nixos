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
}
