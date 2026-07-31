{ pkgs, ... }:
{
  packages = [
    pkgs.zsh
    pkgs.zsh-autosuggestions
    pkgs.zsh-syntax-highlighting
  ];

  # files.".zshrc".source = ./zshrc;
}
