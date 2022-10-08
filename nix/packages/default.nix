{
  pkgs,
  homeConfigurations,
  ...
}:
{
  gtklock = pkgs.callPackage ./gtklock.nix {};
}
// (import ./hm.nix {
  inherit homeConfigurations pkgs;
})
