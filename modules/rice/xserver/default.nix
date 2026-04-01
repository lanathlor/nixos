{ lib, ... }:
{
  services.xserver = {
    enable = true;
    xkb = {
      layout = lib.mkDefault "us";
      variant = "";
    };
  };

}
