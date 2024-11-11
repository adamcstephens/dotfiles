{ pkgs, ... }:
{

  imports = [
    ../apps/atuin
    ../apps/jujutsu
    ../apps/ssh
  ];

  dotfiles.apps.neovim.full = true;

  home.packages = [
    # crypt
    pkgs.passage
    pkgs.rage
    pkgs.rbw

    # nix
    pkgs.nix-output-monitor
    pkgs.nix-tree
    pkgs.nixd
    pkgs.nixfmt-rfc-style

    # tools
    pkgs.pwgen
    pkgs.restish
    pkgs.unzip

    # apps
    pkgs.eternal-terminal
    pkgs.senpai
  ];

  programs = {
    ssh.forwardAgent = true;
  };
}
