{
  pkgs,
  lib,
  ...
}: {
  home.packages = [
    pkgs.vscode
  ];

  programs.vscode = {
    enable = true;
  };
}
