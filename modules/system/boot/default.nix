{ pkgs, ... }:
{
  boot.plymouth = {
    theme = "hexagon_hud";
  };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.supportedFilesystems = [ "ntfs" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.grub = {
    enable = false;
    useOSProber = true;
    efiSupport = true;
    devices = [ "nodev" ];
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth = {
    enable = true;
    themePackages = [ (pkgs.adi1090x-plymouth-themes.override { selected_themes = [ "hexagon_hud" ]; }) ];
  };
}
