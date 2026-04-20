{ inputs, ... }:
let
  illogical-impulse-dotfiles = inputs.illogical-impulse-dotfiles;
  # The local module expects (self, dotfiles, inputs) but after patching,
  # the flake inputs (quickshell, nur) are no longer used.
  iiModule = import ../../modules/illogical-impulse/modules null illogical-impulse-dotfiles inputs;
in
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    iiModule
    ./modules/base.nix
    ./modules/desktop.nix
    ./modules/kitty.nix
    ./modules/nixvim.nix
  ];

  illogical-impulse = {
    enable = true;
    hyprland = {
      ozoneWayland.enable = true;
    };
    dotfiles = {
      fish.enable = true;
      starship.enable = true;
    };
  };

  home.username = "seth";
  home.homeDirectory = "/home/seth";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
