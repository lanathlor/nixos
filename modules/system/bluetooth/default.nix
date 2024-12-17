{ pkgs, ... }:
{
  services.blueman.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings = { General = { Experimental = true; }; };
  hardware.bluetooth.settings.Input = {
    ClassicBondedOnly = false;
  };
  hardware.bluetooth.disabledPlugins = [ "sap" ];
  hardware.bluetooth.package = pkgs.bluez;

  environment.systemPackages = with pkgs; [
    bluez
  ];
}
