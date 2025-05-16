{ ... }:
{
  services.xserver.desktopManager.gnome = {
    enable = true;
  };
  services.xserver.displayManager.gdm.autoSuspend = false;

  # services.xserver.displayManager.sddm.enable = lib.mkForce false;
  # xdg.portal.enable = lib.mkForce false;

  # programs.hyprland.enable = lib.mkForce false;

  # services = {
  #   pipewire = {
  #     enable = lib.mkForce false;
  #   };
  # };
}
