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
      lixPackageSets.latest.nix-init
      lixPackageSets.latest.nix-update
      lixPackageSets.latest.nixpkgs-reviewFull
      lixPackageSets.latest.nurl

      pyright
      treefmt
    ]
    ++ (lib.optionals stdenv.isLinux [
      bubblewrap
      cntr
    ]);

  shellHook = ''
    ln -sf $HOME/.dotfiles/apps/nix/dir-locals.el $PWD/.dir-locals.el
    ln -sfT $HOME/.dotfiles/apps/nix/helix $PWD/.helix

    if [ -d .git ]; then
      mkdir -vp $PWD/.git/info
      ln -sf $HOME/.dotfiles/apps/nix/exclude $PWD/.git/info/exclude
    fi
  '';
}
