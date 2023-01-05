{
  pkgs,
  homeConfigurations,
  ...
}:
{
  revealjs = pkgs.callPackage ../../apps/emacs/revealjs.nix {};
  rush-parallel = pkgs.callPackage ./rush-parallel.nix {};
  terminfo = pkgs.callPackage ./terminfo {};
}
// (import ./hm.nix {
  inherit homeConfigurations pkgs;
})
