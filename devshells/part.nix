{ inputs, withSystem, ... }:
{
  flake.devShells.x86_64-linux = withSystem "x86_64-linux" (
    { pkgs, ... }:
    {
      distrobuilder = pkgs.callPackage ./distrobuilder.nix { };
      # incus = pkgs.callPackage ./incus.nix { };
      xmonad = pkgs.callPackage ./xmonad.nix { };
    }
  );

  perSystem =
    { pkgs, ... }:
    let
      npins = import ../npins;
    in
    {
      _module.args = {
        inherit npins;
      };

      devShells = {
        dotfiles = pkgs.callPackage ./dotfiles.nix { inherit inputs; };

        cd = pkgs.callPackage ./cd.nix { };
        ci = pkgs.callPackage ./ci.nix { inherit inputs; };

        c = pkgs.callPackage ./c.nix { };
        elixir = pkgs.callPackage ./elixir.nix { };
        esphome = pkgs.callPackage ./esphome.nix { };
        go = pkgs.callPackage ./go.nix { };
        js = pkgs.callPackage ./js.nix { };
        media = pkgs.callPackage ./media.nix { };
        nixpkgs = pkgs.callPackage ./nixpkgs.nix { };
        ocaml = pkgs.callPackage ./ocaml.nix { inherit inputs; };
        python = pkgs.callPackage ./python.nix { };
        rust = pkgs.callPackage ./rust.nix { };
        zig = pkgs.callPackage ./zig.nix { };
      };
    };
}
