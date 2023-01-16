{
  pkgs,
  homeConfigurations,
  ...
}:
{
  revealjs = pkgs.callPackage ../../apps/emacs/revealjs.nix {};
  rush-parallel = pkgs.callPackage ./rush-parallel.nix {};
  terminfo = pkgs.callPackage ./terminfo {};
  s0ix-selftest-tool = pkgs.callPackage ./s0ix-selftest-tool {
    kernel = pkgs.linuxPackages_6_0;
  };
  xautocfg = pkgs.callPackage ../../apps/xautocfg/package.nix {};
}
// (import ./hm.nix {
  inherit homeConfigurations pkgs;
})
