{ pkgs, ... }:
let
  # Wrap `start-hyprland` in a D-Bus session. Otherwise start-hyprland exec's
  # itself into `dbus-run-session Hyprland`, losing its place in the process
  # tree and triggering Hyprland's "not started with start-hyprland" warning.
  sessionLauncher = pkgs.writeShellScript "fenos-session-launcher" ''
    set -euo pipefail
    exec ${pkgs.dbus}/bin/dbus-run-session ${pkgs.hyprland}/bin/start-hyprland
  '';
in
{
  services.xserver.enable = false;

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${sessionLauncher}";
      user = "greeter";
    };
  };

  # Don't restart greetd on rebuild: keeps the running session stable.
  systemd.services.greetd.restartIfChanged = false;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.sway.enable = true;
  programs.zsh.enable = true;
  programs.nix-ld.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  security.polkit.enable = true;

  services.journald.extraConfig = ''
    SystemMaxUse=500M
    RuntimeMaxUse=200M
  '';
}
