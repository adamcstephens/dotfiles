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
    pkgs.kalker
    (pkgs.mergiraf.overrideAttrs (
      old:
      lib.optionalAttrs (pkgs.stdenv.hostPlatform.isLinux) {
        env.NIX_CFLAGS_COMPILE =
          lib.throwIf (lib.hasAttr "NIX_CFLAGS_COMPILE" old.env) "remove mergiraf workaround"
            "-fno-strict-aliasing";
      }
    ))
    pkgs.pwgen
    pkgs.sqlite-interactive
    pkgs.step-cli
    pkgs.unzip
  ]
  ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    pkgs.watchexec
  ];
}
