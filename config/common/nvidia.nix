{ config, lib, pkgs, modulesPath, ... }:

{
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  boot.initrd.kernelModules = [ "nvidia" "kvm-intel" "coretemp" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  boot.kernelParams = [ "loglevel=3" "quiet" "nouveau.modeset=0" "ibt=off" "vt.global_cursor_default=0" "module_blacklist=i915" "module_blacklist=amdgpu" ];

  boot.blacklistedKernelModules = [ "nouveau" "nvidiafb" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.nvidia = {

    modesetting.enable = true;

    powerManagement.enable = false;

    open = true;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia.prime = {
    sync.enable = true;

    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}