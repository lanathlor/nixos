{ ... }:
let
  fish = import ./terms/fish { setDefault = true; };
in
{
  imports = [
    ./fileExplorer/thunar.nix
    ./fonts
    # ./homeManager
    ./xserver

    fish
  ];
}
