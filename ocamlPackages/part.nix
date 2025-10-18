{ ... }:
{
  perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    let
      ocamlOverride =
        ocamlPackages:
        ocamlPackages.overrideScope (
          self: super:
          (
            lib.filesystem.packagesFromDirectoryRecursive {
              inherit (self) callPackage;
              directory = ./.;
            }
            |> lib.filterAttrs (n: _: n != "part")
          )
        );
    in
    {
      legacyPackages.ocamlPackages = ocamlOverride pkgs.ocamlPackages;
    };
}
