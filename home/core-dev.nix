{ lib, pkgs, ... }:
{

  imports = [
    ../apps/atuin
    ../apps/emacs
    ../apps/jujutsu
    ../apps/ssh
  ];

  dotfiles.apps = {
    emacs = {
      enable = true;
      full = true;
    };

    neovim.full = true;
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
      pkgs.nix-output-monitor
      pkgs.nix-tree
      pkgs.nixd
      pkgs.nixfmt-rfc-style

      # tools
      pkgs.pgcli
      pkgs.pwgen
      pkgs.restish
      pkgs.unzip
      pkgs.watchexec

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
