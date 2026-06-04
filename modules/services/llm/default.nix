{ pkgs-unstable, ... }:
{
  environment.systemPackages = [
    pkgs-unstable.llama-cpp-rocm
  ];

  # Use only the discrete GPU (skip iGPU)
  environment.sessionVariables.HIP_VISIBLE_DEVICES = "0";

  # Ensure proper permissions for ROCm devices
  services.udev.extraRules = ''
    KERNEL=="kfd", GROUP="render", MODE="0666"
    KERNEL=="renderD*", GROUP="render", MODE="0666"
  '';
}
