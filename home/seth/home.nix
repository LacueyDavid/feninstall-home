{ pkgs, ... }:
{
  home.username = "seth";
  home.homeDirectory = "/home/seth";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "seth";
    userEmail = "seth@example.com";
  };

  programs.zsh.enable = true;

  home.packages = with pkgs; [
    htop
    ripgrep
    fd
  ];
}
