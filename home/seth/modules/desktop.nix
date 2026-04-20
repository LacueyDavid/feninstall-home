{ lib, ... }:
{
  # Hyprland compositor, UI and runtime are now handled by illogical-impulse module.
  # Original imports preserved below for reference:
  # imports = [
  #   ./hypr/compositor.nix
  #   ./hypr/ui.nix
  #   ./hypr/runtime.nix
  # ];

  # Override illogical-impulse dotfiles with local patched versions
  # (fixes deprecated Hyprland 0.54+ options)
  xdg.configFile."quickshell".source = lib.mkForce ./hypr/live/quickshell;
  xdg.configFile."hypr/hyprland/general.conf".source = lib.mkForce ./hypr/live/hyprland/general.conf;
  xdg.configFile."hypr/hyprland/rules.conf".source = lib.mkForce ./hypr/live/hyprland/rules.conf;
  xdg.configFile."hypr/hyprland/keybinds.conf".source = lib.mkForce ./hypr/live/hyprland/keybinds.conf;
  xdg.configFile."hypr/hyprland/execs.conf".source = lib.mkForce ./hypr/live/hyprland/execs.conf;
  xdg.configFile."hypr/hyprland/colors.conf".source = lib.mkForce ./hypr/live/hyprland/colors.conf;
  xdg.configFile."hypr/hyprland/scripts".source = lib.mkForce ./hypr/live/hyprland/scripts;
  xdg.configFile."hypr/custom".source = lib.mkForce ./hypr/live/custom;
}
