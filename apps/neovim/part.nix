{ inputs, ... }:
{
  perSystem =
    {
      inputs',
      ...
    }:
    let
      pkgs = inputs'.nixpkgs-unstable.legacyPackages;
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

        neovim-full = neovim.override {
          full = true;
          dotvimPlugin = "$HOME/.dotfiles/apps/neovim";
        };
      };
    };
}
