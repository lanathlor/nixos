{ ... }:
let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
    sha256 = "12246mk1xf1bmak1n36yfnr4b0vpcwlp6q66dgvz8ip8p27pfcw2";
  };
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];
}
