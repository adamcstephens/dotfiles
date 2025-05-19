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
      deadnix
      hydra-check
      nix-bisect
      nix-prefetch
      nix-generate-from-cpan
      nix-prefetch-github
      nix-prefetch-scripts
      nix-tree
      nix-update
      nixpkgs-fmt
      nixpkgs-review
      nurl
      pyright
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
