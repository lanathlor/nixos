{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];


  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.supportedFilesystems = [ "nfs" ];
  boot.initrd.kernelModules = [ "kvm-intel" "nfs" ];
  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/a8b45e48-e5aa-4231-9725-697c869c4356";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/3B98-19EA";
      fsType = "vfat";
    };


  fileSystems."/mnt/lanath" = {
    device = "nfs.master.monkey:/lanath";
    fsType = "nfs";
    options = [ "rw" "user" "noauto" "x-systemd.automount" "x-systemd.idle-timeout=600" ];
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/210c39d2-7ca4-4437-894f-7f674aca4106"; }];

  networking.useDHCP = lib.mkForce true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
