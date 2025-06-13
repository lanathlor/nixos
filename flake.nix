{
  description = "NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    stamusctl.url = "github:StamusNetworks/stamusctl";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, stamusctl, zen-browser, ... }:
    let
      system = "x86_64-linux";

      myOverlays = [
        (import ./overlays/waybar.nix)
      ];

      pkgs = import nixpkgs {
        inherit system;
        overlays = myOverlays;
      };

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      sharedSpecialArgs = {
        inherit system pkgs-unstable stamusctl zen-browser;
      };

      homeManagerModule = {
        nixpkgs.overlays = myOverlays;
        home-manager.useUserPackages = true;
        home-manager.useGlobalPkgs = true;
        home-manager.extraSpecialArgs = sharedSpecialArgs;
        home-manager.users.lanath = import ./home/lanath.nix;
        home-manager.users.mushu = import ./home/mushu.nix;
      };

      mkHost = hostFile: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = sharedSpecialArgs;
        modules = [
          hostFile
          home-manager.nixosModules.home-manager
          homeManagerModule
        ];
      };

    in
    {
      overlays = { };

      packages.${system}.stamusctl = pkgs.stamusctl;

      nixosConfigurations = {
        lanath-desktop = mkHost ./hosts/lanath-desktop.nix;
        lanath-laptop = mkHost ./hosts/lanath-laptop.nix;
        mushu-desktop = mkHost ./hosts/mushu-desktop.nix;
        mushu-laptop = mkHost ./hosts/mushu-laptop.nix;
      };
    };
}
