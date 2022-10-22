{
  pkgs,
  homeConfigurations,
  ...
}:
{
  gtklock = pkgs.callPackage ./gtklock.nix {};
  terminfo = pkgs.callPackage ./terminfo {};
}
// (import ./hm.nix {
  inherit homeConfigurations pkgs;
})
