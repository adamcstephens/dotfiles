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
          neovim = inputs'.neovim-nightly-overlay.packages.neovim;
        };

        neovim-full = neovim.override {
          full = true;
          dotvimPlugin = "$HOME/.dotfiles/apps/neovim";
        };
      };
    };
}
