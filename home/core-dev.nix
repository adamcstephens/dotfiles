{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  eternal-terminal = pkgs.symlinkJoin {
    name = "eternal-terminal-wrapped";
    paths = [ pkgs.eternal-terminal ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/et --set ET_NO_TELEMETRY "true";
    '';
    meta.mainProgram = "et";
  };
in
{

  imports = [
    ../apps/atuin
    ../apps/ruff
    ../apps/ssh
    ../apps/zk
    inputs.nix-index-database.homeModules.nix-index
  ];

  dotfiles = {
    apps = {
      neovim.full = true;
    };

    dev.enable = true;
  };

  home.packages = [
    # crypt
    # remove 25.11
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.pinentry-curses
    pkgs.rage
    pkgs.rbw

    # nix
    pkgs.hydra-check
    pkgs.nix-output-monitor
    pkgs.nix-tree
    pkgs.nixd
    pkgs.nixfmt-rfc-style
    pkgs.nvd

    # tools
    pkgs.pwgen
    pkgs.step-cli
    pkgs.unzip
    pkgs.watchexec

    # apps
    eternal-terminal
  ]
  ++ lib.optionals pkgs.stdenv.isLinux [
    pkgs._1password-cli
    pkgs.bws
  ];
}
