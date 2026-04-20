{
  description = "Illogical Impulse Hyprland Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    systems.url = "github:nix-systems/default-linux";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    illogical-impulse-dotfiles = {
      url = "github:xBLACKICEx/dots-hyprland?ref=tmp";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, illogical-impulse-dotfiles, systems, ... }@ inputs:
    let
      inherit (nixpkgs) lib;
      eachSystem = lib.genAttrs (import systems);
    in
    {
      legacyPackages = eachSystem (
        system:
        import ./pkgs {
          pkgs = nixpkgs.legacyPackages.${system};
        }
      );
      homeManagerModules.default = import ./modules self illogical-impulse-dotfiles inputs;
    };
}
