{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    qemu
  ];

  virtualisation.libvirtd.enable = true; # Optional: for libvirt/KVM support
  users.users.lanath.extraGroups = [ "libvirtd" ]; # Add your user to the group
}
