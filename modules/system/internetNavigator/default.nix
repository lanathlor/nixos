{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    firefox
    google-chrome
    chromium
    google-chrome
    tor
    playwright-driver
    steam-run
  ];
}
