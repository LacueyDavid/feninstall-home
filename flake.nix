{
  description = "Fenos post-install config (NixOS + Home Manager)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    illogical-impulse-dotfiles = {
      url = "github:xBLACKICEx/dots-hyprland?ref=tmp";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";

      homeManagerModule = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "hm-backup";
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.users.seth = import ./home/seth.nix;
        home-manager.users.root = import ./home/root.nix;
      };

      mkHost = hostModule: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          hostModule
          home-manager.nixosModules.home-manager
          homeManagerModule
        ];
      };
    in {
      nixosConfigurations.pc      = mkHost ./hosts/pc.nix;
      nixosConfigurations.vm      = mkHost ./hosts/vm.nix;
      nixosConfigurations.default = self.nixosConfigurations.pc;
    };
}
