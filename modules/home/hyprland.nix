{ lib, ... }:
let
  dotfiles = ../../dotfiles/hypr;
in
{
  # illogical-impulse provides the baseline Hyprland wiring (enables the HM
  # module, sets up hypridle, sources the dotfiles bundle). We only override
  # the .conf files it ships so we can ship fixes without forking upstream.
  xdg.configFile = {
    "hypr/hyprland/general.conf".source  = lib.mkForce "${dotfiles}/hyprland/general.conf";
    "hypr/hyprland/rules.conf".source    = lib.mkForce "${dotfiles}/hyprland/rules.conf";
    "hypr/hyprland/keybinds.conf".source = lib.mkForce "${dotfiles}/hyprland/keybinds.conf";
    "hypr/hyprland/execs.conf".source    = lib.mkForce "${dotfiles}/hyprland/execs.conf";
    "hypr/hyprland/colors.conf".source   = lib.mkForce "${dotfiles}/hyprland/colors.conf";
    "hypr/hyprland/scripts".source       = lib.mkForce "${dotfiles}/hyprland/scripts";
    "hypr/custom".source                 = lib.mkForce "${dotfiles}/custom";
  };
}
