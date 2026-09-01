{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../apps/agents
    ../apps/atuin
    ../apps/epi
    ../apps/ruff
    ../apps/zk
  ];

  dotfiles = {
    apps.neovim.full = true;
    dev.enable = true;
  };

  packages = [
    # crypt
    pkgs.pinentry-curses
    pkgs.rage
    pkgs.rbw

    # nix
    pkgs.hydra-check
    pkgs.nix-output-monitor
    pkgs.nix-tree
    pkgs.nixd
    inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.nixfmt-rs
    pkgs.nvd

    # tools
    pkgs.mergiraf
    pkgs.pwgen
    pkgs.step-cli
    pkgs.unzip
  ]
  ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    pkgs.watchexec
  ];
}
