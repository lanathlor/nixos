{ config, lib, pkgs, modulesPath, localConfig, ... }:

let
  repoUrl = "https://github.com/${localConfig.githubUser}/${localConfig.githubRepo}.git";
in
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  isoImage.isoName = lib.mkForce "nixos-installer.iso";
  isoImage.volumeID = lib.mkForce "NIXOS_INSTALL";

  environment.systemPackages = with pkgs; [
    git
    vim
    parted
    gptfdisk
    dosfstools
    e2fsprogs

    (writeShellScriptBin "install-system" ''
      set -e

      echo ""
      echo "======================================"
      echo "  NixOS Installer"
      echo "======================================"
      echo ""
      echo "Available disks:"
      lsblk -d -o NAME,SIZE,MODEL | grep -v loop
      echo ""

      read -rp "Target disk (e.g., /dev/nvme0n1 or /dev/sda): " DISK

      if [ ! -b "$DISK" ]; then
        echo "Error: $DISK is not a valid block device"
        exit 1
      fi

      echo ""
      echo "WARNING: This will ERASE ALL DATA on $DISK"
      read -rp "Type 'yes' to continue: " CONFIRM

      if [ "$CONFIRM" != "yes" ]; then
        echo "Aborted."
        exit 1
      fi

      if [[ "$DISK" == *"nvme"* ]] || [[ "$DISK" == *"mmcblk"* ]]; then
        PART_PREFIX="''${DISK}p"
      else
        PART_PREFIX="''${DISK}"
      fi

      echo ""
      echo "==> Partitioning $DISK..."

      umount -R /mnt 2>/dev/null || true
      swapoff -a 2>/dev/null || true

      parted -s "$DISK" mklabel gpt
      parted -s "$DISK" mkpart ESP fat32 1MiB 513MiB
      parted -s "$DISK" set 1 esp on
      parted -s "$DISK" mkpart swap linux-swap 513MiB 8705MiB
      parted -s "$DISK" mkpart root ext4 8705MiB 100%

      sleep 1

      echo "==> Formatting partitions..."

      mkfs.fat -F32 -n BOOT "''${PART_PREFIX}1"
      mkswap -L swap "''${PART_PREFIX}2"
      mkfs.ext4 -L nixos "''${PART_PREFIX}3"

      echo "==> Mounting partitions..."

      mount "''${PART_PREFIX}3" /mnt
      mkdir -p /mnt/boot
      mount "''${PART_PREFIX}1" /mnt/boot
      swapon "''${PART_PREFIX}2"

      echo "==> Cloning configuration repository..."

      git clone ${repoUrl} /mnt/etc/nixos

      echo "==> Generating hardware configuration..."

      nixos-generate-config --root /mnt --show-hardware-config > /mnt/etc/nixos/hosts/hardware-configuration.nix

      echo "==> Installing NixOS..."

      nixos-install --flake /mnt/etc/nixos#default --no-root-passwd

      echo ""
      echo "======================================"
      echo "  Installation complete!"
      echo "======================================"
      echo ""
      echo "Next steps:"
      echo "  1. Edit /mnt/etc/nixos/local.nix with your personal config"
      echo "  2. Add SSH keys to /mnt/etc/nixos/keys/"
      echo "  3. Set root password: nixos-enter --root /mnt -c 'passwd'"
      echo "  4. Set user password: nixos-enter --root /mnt -c 'passwd <username>'"
      echo "  5. Reboot: reboot"
      echo ""
    '')
  ];

  services.getty.helpLine = lib.mkForce ''

    Welcome to NixOS Installer

    Run 'install-system' to begin installation.

    Manual commands available:
      - install-system : Interactive installer
      - nmtui          : Configure network
      - lsblk          : List block devices

  '';
}
