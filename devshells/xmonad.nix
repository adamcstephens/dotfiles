{ pkgs, mkShellNoCC }:

mkShellNoCC {
  packages = [
    (pkgs.ghc.withPackages (ps: [
      ps.haskell-language-server
      ps.ormolu
      ps.xmonad
      ps.xmonad-contrib
    ]))
  ];
}
