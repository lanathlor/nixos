{
  description = "NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, ... }: {
    nixosConfigurations.lanath-desktop = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs =
        {
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        };
      modules = [
        ./hosts/lanath-desktop.nix
      ];
    };
  };
}
