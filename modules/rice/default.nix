{ ... }:
let
  fish = import ./terms/fish { setDefault = true; };
in
{
  imports = [
    ./fileExplorer/thunar.nix
    ./fonts
    ./homeManager
    ./terms/starship.nix
    ./xserver

    fish
  ];
}
