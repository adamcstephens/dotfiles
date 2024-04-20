{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.git
    inputs.sandbox.packages.${pkgs.system}.git-toolbelt
  ];
  xdg.configFile = {
    "git/config".source = ./gitconfig;

    "git/ignore".text = lib.concatStringsSep "\n" [
      "*.log"
      "*.retry"
      ".DS_Store"
      ".direnv/"
      ".lsp/"
      ".worktree/"
      "result"
    ];
  };
}
