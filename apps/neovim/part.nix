{ inputs, ... }:
{
  perSystem =
    {
      inputs',
      ...
    }:
    let
      pkgs = inputs'.nixpkgs.legacyPackages;
    in
    {
      packages = rec {
        neovim = pkgs.callPackage ./package.nix {
          inherit (inputs) mnw;
          neovim = pkgs.neovim-unwrapped;
        };

        neovim-full = neovim.override {
          full = true;
          dotvimPlugin = "$HOME/.dotfiles/apps/neovim";
        };
      };
    };
}
