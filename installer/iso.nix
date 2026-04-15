{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  # ISO label
  isoImage.isoName = lib.mkForce "nixos-lanath-installer.iso";
  isoImage.volumeID = lib.mkForce "NIXOS_INSTALL";

  # Packages available in the live environment
  environment.systemPackages = with pkgs; [
    git
    vim
    parted
    gptfdisk
    dosfstools
    e2fsprogs

    # Interactive install script
    (writeShellScriptBin "install-system" ''
      set -e

      echo ""
      echo "======================================"
      echo "  NixOS Installer - lanathlor/nixos"
      echo "======================================"
      echo ""

      # List available configs
      echo "Available host configurations:"
      echo "  - lanath-desktop"
      echo "  - lanath-laptop"
      echo "  - mushu-desktop"
      echo "  - mushu-laptop"
      echo ""

      read -rp "Target hostname: " HOSTNAME

      # Validate hostname
      case "$HOSTNAME" in
        lanath-desktop|lanath-laptop|mushu-desktop|mushu-laptop)
          echo "Using configuration: $HOSTNAME"
          ;;
        *)
          echo "Error: Unknown hostname '$HOSTNAME'"
          exit 1
          ;;
      esac

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

      # Determine partition suffix (nvme uses p1, sata uses 1)
      if [[ "$DISK" == *"nvme"* ]] || [[ "$DISK" == *"mmcblk"* ]]; then
        PART_PREFIX="''${DISK}p"
      else
        PART_PREFIX="''${DISK}"
      fi

      echo ""
      echo "==> Partitioning $DISK..."

      # Unmount if mounted
      umount -R /mnt 2>/dev/null || true
      swapoff -a 2>/dev/null || true

      # Create GPT partition table
      parted -s "$DISK" mklabel gpt

      # Create EFI partition (512MB)
      parted -s "$DISK" mkpart ESP fat32 1MiB 513MiB
      parted -s "$DISK" set 1 esp on

      # Create swap partition (8GB)
      parted -s "$DISK" mkpart swap linux-swap 513MiB 8705MiB

      # Create root partition (rest)
      parted -s "$DISK" mkpart root ext4 8705MiB 100%

      sleep 1  # Wait for kernel to recognize partitions

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

      git clone https://github.com/lanathlor/nixos.git /mnt/etc/nixos

      echo "==> Generating hardware configuration..."

      # Generate hardware config for this specific machine
      nixos-generate-config --root /mnt --show-hardware-config > /mnt/etc/nixos/hosts/''${HOSTNAME}-hardware-configuration.nix

      echo "==> Installing NixOS with configuration '$HOSTNAME'..."

      nixos-install --flake /mnt/etc/nixos#"$HOSTNAME" --no-root-passwd

      echo ""
      echo "======================================"
      echo "  Installation complete!"
      echo "======================================"
      echo ""
      echo "Next steps:"
      echo "  1. Set root password: nixos-enter --root /mnt -c 'passwd'"
      echo "  2. Set user password: nixos-enter --root /mnt -c 'passwd lanath'"
      echo "  3. Reboot: reboot"
      echo ""
    '')
  ];

  # Start with a helpful message
  services.getty.helpLine = lib.mkForce ''

    Welcome to NixOS Installer (lanathlor/nixos)

    Run 'install-system' to begin installation.

    Manual commands available:
      - install-system : Interactive installer
      - nmtui          : Configure network
      - lsblk          : List block devices

  '';
}
