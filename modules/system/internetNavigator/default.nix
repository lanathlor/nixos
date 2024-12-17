{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    firefox-wayland
    google-chrome
    chromium
    tor
  ];
}
