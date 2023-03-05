{
  pkgs,
  homeConfigurations,
  ...
}:
{
  revealjs = pkgs.callPackage ../../apps/emacs/revealjs.nix {};
  terminfo = pkgs.callPackage ./terminfo {};
}
// (import ./hm.nix {
  inherit homeConfigurations pkgs;
})
