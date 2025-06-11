{ ... }:
{
  imports = [
    ./de/gnome.nix
    ./theme/nordic
  ];

  home-manager.users.mushu = { pkgs, pkgs-unstable, ... }: {
    imports = [
      ./de/lanath.nix
      ./dunst
      ./git/mushu.nix
      ./homeManager/lanath.nix
      ./lock/swaylock.nix
      ./rofi
      ./rofi
      ./terms/fish/lanath.nix
      ./terms/starship.nix
      ./theme/nordic/homeManager.nix
      ./xserver/mushu.nix
    ];
  };
}
