{ pkgs-unstable, ... }:
{
  imports = [
    ./de/hyprland.nix
    ./theme/nordic
  ];

  home-manager.extraSpecialArgs = {
    pkgs-unstable = pkgs-unstable;
  };
  home-manager.users.lanath = { pkgs, ... }: {
    imports = [
      ./de/lanath.nix
      ./dunst
      ./git/lanath.nix
      ./homeManager/lanath.nix
      ./lock/swaylock.nix
      ./rofi
      ./rofi
      ./terms/fish/lanath.nix
      ./terms/starship.nix
      ./theme/nordic/homeManager.nix
      ./xserver/lanath.nix
    ];
  };
}
