{ lib, pkgs, ... }:
{

  imports = [
    ../apps/atuin
    ../apps/emacs
    ../apps/jujutsu
    ../apps/ssh
    ../apps/zk
  ];

  dotfiles = {
    apps = {
      emacs.enable = false;
      neovim.full = true;
    };

    dev.enable = true;
  };

  home.packages =
    [
      # crypt
      pkgs.passage
      pkgs.pinentry.curses
      pkgs.rage
      pkgs.rbw

      # lang
      pkgs.elixir-ls
      pkgs.next-ls

      # nix
      pkgs.hydra-check
      pkgs.nix-output-monitor
      pkgs.nix-tree
      pkgs.nixd
      pkgs.nixfmt-rfc-style
      pkgs.nvd

      # tools
      pkgs.pgcli
      pkgs.pwgen
      pkgs.restish
      pkgs.step-cli
      pkgs.unzip
      pkgs.watchexec

      # apps
      pkgs.eternal-terminal
      pkgs.senpai
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      pkgs._1password-cli
    ];
}
