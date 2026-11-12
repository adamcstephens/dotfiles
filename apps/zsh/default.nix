{ dotlib, pkgs, ... }:
{
  home.packages = [
    pkgs.zsh
    pkgs.zsh-autosuggestions
    pkgs.zsh-syntax-highlighting
  ];

  home.file.".zshrc".source = dotlib.source "apps/zsh/zshrc";
}
