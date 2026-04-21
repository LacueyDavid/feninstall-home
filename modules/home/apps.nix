{ pkgs, ... }:
{
  xdg.enable = true;

  programs.firefox.enable = true;

  home.packages = with pkgs; [
    mupdf
    telegram-desktop
    vscode
  ];
}
