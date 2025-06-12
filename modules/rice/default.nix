{ ... }:
let
  fish = import ./terms/fish { setDefault = true; };
in
{
  imports = [
    ./fileExplorer/thunar.nix
    ./fonts
    # ./homeManager
    ./terms/fish/lanath.nix
    ./terms/starship.nix
    ./xserver

    fish
  ];
}
