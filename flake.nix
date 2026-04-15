{
  description = "NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    stamusctl.url = "github:StamusNetworks/stamusctl";

    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      stamusctl,
      zen-browser,
      nur,
      vscode-server,
      sops-nix,
      ...
    }:

    let
      system = "x86_64-linux";

      myOverlays = [
        (import ./overlays/waybar.nix)
        (import ./overlays/curseforge.nix)
        (import ./overlays/wago-addons.nix)
        (import ./overlays/warcraftlogs.nix)
        (import ./overlays/claude-code.nix)
        (import ./overlays/codex.nix)
        (import ./overlays/opencode.nix)
      ];

      pkgs = import nixpkgs {
        inherit system;
        overlays = myOverlays;
      };

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      # Override stamusctl with correct vendorHash
      stamusctl-fixed = {
        packages.${system}.default = stamusctl.packages.${system}.default.overrideAttrs (oldAttrs: {
          vendorHash = "sha256-NvuiyrMfgpGDBGyLFt1wtmGI1dlAicN4DpITF/rBUUQ=";
        });
      };

      sharedSpecialArgs = {
        inherit
          inputs
          system
          pkgs-unstable
          zen-browser
          nur
          ;
        stamusctl = stamusctl-fixed;
      };

      homeManagerModule = {
        nixpkgs.overlays = myOverlays;
        home-manager.useUserPackages = true;
        home-manager.useGlobalPkgs = true;
        home-manager.backupFileExtension = "bak";
        home-manager.extraSpecialArgs = sharedSpecialArgs;
        home-manager.users.lanath = import ./home/lanath.nix;
        home-manager.users.mushu = import ./home/mushu.nix;
      };

      mkHost =
        hostFile:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = sharedSpecialArgs;
          modules = [
            hostFile
            home-manager.nixosModules.home-manager
            homeManagerModule
            nur.modules.nixos.default
          ];
        };

      mkHostWithVscodeServer =
        hostFile:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = sharedSpecialArgs;
          modules = [
            hostFile
            home-manager.nixosModules.home-manager
            homeManagerModule
            nur.modules.nixos.default
            vscode-server.nixosModules.default
            { services.vscode-server.enable = true; }
          ];
        };

    in
    {
      overlays = { };

      packages.${system} = {
        stamusctl = pkgs.stamusctl;
        curseforge = pkgs.curseforge;
        wago-addons = pkgs.wago-addons;
        warcraftlogs = pkgs.warcraftlogs;
      };

      nixosConfigurations = {
        lanath-desktop = mkHostWithVscodeServer ./hosts/lanath-desktop.nix;
        lanath-laptop = mkHost ./hosts/lanath-laptop.nix;
        mushu-desktop = mkHost ./hosts/mushu-desktop.nix;
        mushu-laptop = mkHost ./hosts/mushu-laptop.nix;
      };

      tests = {
        nixos-test = nixpkgs.lib.nixosSystem {
          system = system;
          modules = [ ./tests/nixos-test.nix ];
        };
      };
    };
}
