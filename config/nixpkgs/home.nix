{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = [
    pkgs.bat
    pkgs.colordiff
    pkgs.ctags
    pkgs.direnv
    pkgs.fira-code
    pkgs.firefox
    pkgs.fzf
    pkgs.gnumake
    pkgs.htop
    pkgs.httpie
    pkgs.jq
    pkgs.kitty
    pkgs.neovim
    pkgs.nmap
    pkgs.python37Packages.yamllint
    pkgs.shellcheck
    pkgs.silver-searcher
    pkgs.tmux
    pkgs.tree
    pkgs.vscodium
    pkgs.wget
    pkgs.xcape
  ];
}
