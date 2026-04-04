{ ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    extraConfig = builtins.readFile ./live/hyprland.conf;
  };

  xdg.configFile = {
    "hypr/hyprland".source = ./live/hyprland;
    "hypr/custom".source = ./live/custom;
    "hypr/monitors.conf".source = ./live/monitors.conf;
    "hypr/workspaces.conf".source = ./live/workspaces.conf;
    "hypr/hyprlock/colors.conf".source = ./live/hyprlock/colors.conf;
  };
}
