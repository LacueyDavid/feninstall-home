{ lib, ... }:
let
  # Our patched quickshell config (from dots-hyprland / illogical-impulse).
  shellConfig = ../../dotfiles/hypr/quickshell/ii;
in
{
  # illogical-impulse installs `quickshell/ii` — we override the whole
  # directory with our patched copy AND expose it as `default` too, so that
  # plain `quickshell` (no -c) works as well as `quickshell -c ii`.
  xdg.configFile = {
    "quickshell/ii".source      = lib.mkForce shellConfig;
    "quickshell/default".source = shellConfig;
  };
}
