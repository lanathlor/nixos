{ ... }: {
  imports = [
    ../modules/devel/vscode/lanath.nix
    ../modules/devel/vscode/lanath.nix
    ../modules/rice/de/lanath.nix
    ../modules/rice/dunst
    ../modules/rice/git/lanath.nix
    ../modules/rice/homeManager/lanath.nix
    ../modules/rice/lock/swaylock.nix
    ../modules/rice/rofi
    ../modules/rice/rofi
    ../modules/rice/terms/fish/lanath.nix
    ../modules/rice/terms/starship.nix
    ../modules/rice/theme/nordic/homeManager.nix
    ../modules/rice/xserver/lanath.nix

    ./programs/browsers.nix
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
