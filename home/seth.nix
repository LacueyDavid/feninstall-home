{ inputs, ... }:
let
  illogicalImpulse = import ../modules/illogical-impulse/modules
    null
    inputs.illogical-impulse-dotfiles
    inputs;
in
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    illogicalImpulse
    ../modules/home
  ];

  illogical-impulse = {
    enable = true;
    hyprland.ozoneWayland.enable = true;
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
