{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wineWowPackages.stable
    wine
    (wine.override { wineBuild = "wine64"; })
    wine64
    wineWowPackages.staging
    winetricks
    wineWowPackages.waylandFull
    (wineWowPackages.full.override {
      wineRelease = "staging";
      mingwSupport = true;
    })
    wowup-cf
  ];
}
