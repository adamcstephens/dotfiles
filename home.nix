{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.username = "astephe9";
  home.homeDirectory = (builtins.getEnv "HOME");

  home.stateVersion = "21.11";

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.packages = [
    pkgs.htop
    pkgs.zstd
  ];
}
