{ lib, ... }:
{
  hardware.enableAllFirmware = true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
