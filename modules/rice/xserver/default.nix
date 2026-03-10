{ lib, ... }:
{
  services.xserver = {
    enable = true;
    xkb = {
      layout = lib.mkDefault "us";
      variant = "";
    };
  };

  services.displayManager.gdm = {
    wayland = true;
    enable = true;
    settings.General.DisplayServer = "x11-user";
  };
}
