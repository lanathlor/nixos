{
  description = "NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    stamusctl.url = "github:StamusNetworks/stamusctl";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, stamusctl, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ self.overlays.stamusctl ];
      };
    in
    {
      overlays = { };

      packages.${system}.stamusctl = pkgs.stamusctl;

      nixosConfigurations.lanath-desktop = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";


        specialArgs =
          {
            pkgs-unstable = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };

            stamusctl = inputs.stamusctl;
          };
        modules = [
          ./hosts/lanath-desktop.nix

        ];
      };
    };
}
