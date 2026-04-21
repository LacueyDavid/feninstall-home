{ pkgs, ... }:
{
  users.users.seth = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  environment.systemPackages = with pkgs; [
    curl
    fd
    git
    htop
    neovim
    networkmanager
    ripgrep
    wget
  ];
}
