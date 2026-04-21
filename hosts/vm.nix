{ lib, pkgs, ... }:
let
  vmSessionLauncher = pkgs.writeShellScript "fenos-vm-session-launcher" ''
    set -euo pipefail
    exec ${pkgs.bash}/bin/bash -lc 'exec dbus-run-session sh -lc "Hyprland || exec sway"'
  '';
in
{
  imports = [ ./default.nix ];

  boot.initrd.availableKernelModules = lib.mkAfter [
    "virtio_pci"
    "virtio_blk"
    "virtio_scsi"
  ];

  # VM-only: fall back to sway if Hyprland fails on a fragile virtual GPU.
  services.greetd.settings.default_session = {
    command = lib.mkForce "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${vmSessionLauncher}";
    user = lib.mkForce "greeter";
  };
}
