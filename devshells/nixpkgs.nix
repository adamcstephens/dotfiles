{
  lib,
  mkShellNoCC,
  stdenv,

  bubblewrap,
  common-updater-scripts,
  cntr,
  deadnix,
  hydra-check,
  nix-bisect,
  nix-generate-from-cpan,
  nix-prefetch,
  nix-prefetch-github,
  nix-prefetch-scripts,
  nix-tree,
  nix-update,
  nixpkgs-fmt,
  nixpkgs-review,
  nurl,
}:
mkShellNoCC {
  name = "nixpkgs-devshell";

  packages = [
    cntr
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
  ] ++ (lib.optionals stdenv.isLinux [ bubblewrap ]);

  shellHook = ''
    ln -sf $HOME/.dotfiles/apps/nix/dir-locals.el $PWD/.dir-locals.el
    ln -sfT $HOME/.dotfiles/apps/nix/vscode $PWD/.vscode
    ln -sfT $HOME/.dotfiles/apps/nix/vscode $PWD/.vscodium
    ln -sfT $HOME/.dotfiles/apps/nix/helix $PWD/.helix

    if [ -d .git ]; then
      mkdir -vp $PWD/.git/info
      ln -sf $HOME/.dotfiles/apps/nix/exclude $PWD/.git/info/exclude
    fi
  '';
}
