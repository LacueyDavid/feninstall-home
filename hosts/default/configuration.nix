{ pkgs, ... }:
{
  system.stateVersion = "25.05";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  users.users.seth = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    git
    neovim
    wget
  ];
}
