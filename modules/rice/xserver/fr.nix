{ lib, ... }:
{
  console.keyMap = "fr";

  services.xserver = {
    xkb = {
      layout = "fr";
      variant = lib.mkForce "azerty";
    };
  };

  services.xserver.desktopManager.gnome = {
    extraGSettingsOverrides = ''
      [org.gnome.desktop.input-sources]
        sources=[('xkb', 'fr')]
    '';
  };
}
