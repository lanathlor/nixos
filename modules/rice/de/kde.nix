{ ... }:
{
  # KDE Plasma 6 desktop. Adds Plasma (Wayland + X11) session files that regreet
  # lists alongside Hyprland — both are selectable at the login screen. Coexists
  # with Hyprland and does not force a display manager (greetd/regreet stays in place).
  services.desktopManager.plasma6.enable = true;
}
