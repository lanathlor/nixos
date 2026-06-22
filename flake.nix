{
  description = "NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    plasma-manager.url = "github:nix-community/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";

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

    claude-desktop.url = "github:aaddrick/claude-desktop-debian";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      plasma-manager,
      stamusctl,
      zen-browser,
      nur,
      vscode-server,
      claude-desktop,
      sops-nix,
      ...
    }:

    let
      system = "x86_64-linux";

      localConfig = nixpkgs.lib.recursiveUpdate (import ./config-defaults.nix) (import ./local.nix);

      myOverlays = [
        (import ./overlays/waybar.nix { weatherConfig = localConfig.weather; })
        (import ./overlays/curseforge.nix)
        (import ./overlays/wago-addons.nix)
        (import ./overlays/warcraftlogs.nix)
        (import ./overlays/claude-code.nix)
        (import ./overlays/codex.nix)
        (import ./overlays/opencode.nix)
        claude-desktop.overlays.default
      ];

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
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
          localConfig
          ;
        stamusctl = stamusctl-fixed;
      };

      homeManagerModule = {
        nixpkgs.overlays = myOverlays;
        home-manager.useUserPackages = true;
        home-manager.useGlobalPkgs = true;
        home-manager.backupFileExtension = "bak";
        home-manager.extraSpecialArgs = sharedSpecialArgs;
        home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
        home-manager.users = builtins.mapAttrs (name: _: import ./home) localConfig.users;
      };

      vscodeServerModule = nixpkgs.lib.optionalAttrs localConfig.vscodeServer.enable {
        imports = [
          vscode-server.nixosModules.default
          { services.vscode-server.enable = true; }
        ];
      };

    in
    {
      overlays = { };

      packages.${system} = {
        curseforge = pkgs.curseforge;
        wago-addons = pkgs.wago-addons;
        warcraftlogs = pkgs.warcraftlogs;
      };

      nixosConfigurations = {
        default = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = sharedSpecialArgs;
          modules = [
            ./hosts/default.nix
            home-manager.nixosModules.home-manager
            homeManagerModule
            nur.modules.nixos.default
            vscodeServerModule
          ];
        };

        # Installer ISO
        installer = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit localConfig; };
          modules = [ ./installer/iso.nix ];
        };
      };

      # ISO image for easy building
      images.${system} = {
        installer = self.nixosConfigurations.installer.config.system.build.isoImage;
      };

      # Checks that run on `nix flake check`
      checks.${system} = {
        eval-default = self.nixosConfigurations.default.config.system.build.toplevel;

        # VM integration tests
        vm-test = import ./tests/nixos-test.nix { inherit pkgs; };
        hyprland-test = import ./tests/hyprland-test.nix { inherit pkgs; };
      };
    };
}