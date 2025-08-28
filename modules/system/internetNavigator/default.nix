{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    firefox-wayland
    google-chrome
    chromium
    google-chrome
    tor
    playwright-driver
    steam-run
  ];
}
