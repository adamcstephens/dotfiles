{ lib, pkgs, ... }:
{

  imports = [
    ../apps/atuin
    ../apps/jujutsu
    ../apps/ssh
  ];

  dotfiles.apps.neovim.full = true;

  home.packages =
    [
      # crypt
      pkgs.passage
      pkgs.rage
      pkgs.rbw

      # lang
      pkgs.python313
      # (pkgs.python313.withPackages (
      #   ps: with ps; [
      #     python-lsp-server
      #     pylsp-mypy
      #   ]
      # ))

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
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      pkgs._1password-cli
    ];

  programs = {
    ssh.forwardAgent = true;
  };
}
