# This module defines a small NixOS installation CD.  It does not
# contain any graphical stuff.
{ config, pkgs, lib, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>

    # # Provide an initial copy of the NixOS channel so that the user
    # # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  boot.kernelPackages = lib.mkForce (pkgs.linuxPackagesFor (pkgs.linux));

  boot.supportedFilesystems = lib.mkForce [ "btrfs" "cifs" "f2fs" "jfs" "ntfs" "reiserfs" "vfat" "xfs" ];

  isoImage.squashfsCompression = "gzip -Xcompression-level 1";

  # networking.networkmanager.enable = false;
  networking.wireless.enable = false;

  users.users.lanath = lib.mkForce {
    isNormalUser = true;
    description = "lanath";
    extraGroups = [ "networkmanager" "wheel" "storage" ];
    initialPassword = "";
    packages = with pkgs; [
    ];
  };

}