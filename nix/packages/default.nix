{
  pkgs,
  homeConfigurations,
  ...
}:
{
  rush-parallel = pkgs.callPackage ./rush-parallel.nix {};
  gtklock = pkgs.callPackage ./gtklock.nix {};
  terminfo = pkgs.callPackage ./terminfo {};
}
// (import ./hm.nix {
  inherit homeConfigurations pkgs;
})
