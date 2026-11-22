{ dotlib, pkgs, ... }:
{
  home.packages = [
    pkgs.zsh
    pkgs.zsh-autosuggestions
    pkgs.zsh-syntax-highlighting
  ];

  smfh.files.".zshrc".source = dotlib.source "apps/zsh/zshrc";
}
