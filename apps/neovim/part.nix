{ inputs, ... }:
{
  perSystem =
    {
      inputs',
      ...
    }:
    let
      pkgs = inputs'.nixpkgs-unstable-small.legacyPackages;
    in
    {
      packages = rec {
        neovim = pkgs.callPackage ./package.nix {
          inherit (inputs) mnw;
          neovim = pkgs.neovim-unwrapped;
          golangci-lint-langserver = pkgs.golangci-lint-langserver.overrideAttrs (_: {
            doCheck = false;
          });
        };

        neovim-full = neovim.override { full = true; };
      };
    };
}
