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
    kernel = pkgs.linuxPackages_latest;
  };
  xautocfg = pkgs.callPackage ../../apps/xautocfg/package.nix {};
  xmos_dfu = pkgs.callPackage ./xmos_dfu {};
}
// (import ./hm.nix {
  inherit homeConfigurations pkgs;
})
