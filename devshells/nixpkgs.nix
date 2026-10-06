{
  lib,
  mkShellNoCC,
  pkgs,
  stdenv,
}:
mkShellNoCC {
  name = "nixpkgs-devshell";

  packages =
    with pkgs;
    [
      common-updater-scripts
      nix-diff
      nix-init
      nix-update
      nixpkgs-reviewFull
      nurl

      pyright
      treefmt
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      bubblewrap
      cntr
    ];

  shellHook = ''
    ln -sfT $HOME/.dotfiles/apps/nix/AGENTS.md $PWD/AGENTS.md

    if [ -d .git ]; then
      mkdir -vp $PWD/.git/info
      ln -sf $HOME/.dotfiles/apps/nix/exclude $PWD/.git/info/exclude
    fi
  '';
}
