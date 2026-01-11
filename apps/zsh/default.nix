{ pkgs, ... }:
{
  home.packages = [
    pkgs.zsh
    pkgs.zsh-autosuggestions
    pkgs.zsh-syntax-highlighting
  ];

  home.file.".zshrc".source = ./zshrc;
}
