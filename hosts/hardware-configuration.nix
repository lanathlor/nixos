{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/75f3de38-13b6-4b30-babe-89fa3cc8cd02";
    fsType = "ext4";
  };

  fileSystems."/home/lanath/data" = {
    device = "/dev/disk/by-label/data";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1C57-16D4";
    fsType = "vfat";
  };

  fileSystems."/mnt/lanath" = {
    device = "nfs.master.monkey:/lanath";
    fsType = "nfs";
    options = [ "rw" "user" "noauto" "x-systemd.automount" "x-systemd.idle-timeout=600" ];
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkForce true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.enableAllFirmware = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings = { General = { Experimental = true; }; };
  hardware.bluetooth.settings.Input = {
    ClassicBondedOnly = false;
  };
  hardware.bluetooth.disabledPlugins = [ "sap" ];
  hardware.bluetooth.package = pkgs.bluez;

  services.blueman.enable = true;
}
