{ config, lib, pkgs, modulesPath, ... }:

{
  nixpkgs.config.allowUnfree = lib.mkForce true;
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
      config.boot.kernelPackages.nvidia_x11.out
    ];
  };

  environment.systemPackages = with pkgs; [
  ];

  boot.initrd.kernelModules = [ "nvidia" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 config.boot.kernelPackages.evdi ];
  boot.kernelParams = [ "loglevel=3" "quiet" "nouveau.modeset=0" "ibt=off" "vt.global_cursor_default=0" /* "module_blacklist=i915" */ ];

  boot.blacklistedKernelModules = [ "nouveau" "nvidiafb" ];
  boot.kernelPackages = pkgs.linuxPackages;

  hardware.nvidia = {

    modesetting.enable = true;

    powerManagement.enable = false;

    open = true;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  hardware.nvidia.prime = {
    sync.enable = true;

    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  services.xserver.videoDrivers = [ "nvidia" "displaylink" "modesetting" ];
}
