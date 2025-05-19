{ inputs, withSystem, ... }:
{
  flake.devShells.x86_64-linux = withSystem "x86_64-linux" (
    { inputs', ... }:
    let
      pkgs = inputs'.nixpkgs-unstable.legacyPackages;
    in
    {
      distrobuilder = pkgs.callPackage ./distrobuilder.nix { };
      incus = pkgs.callPackage ./incus.nix { };
      xmonad = pkgs.callPackage ./xmonad.nix { };
    }
  );

  perSystem =
    {
      inputs',
      self',
      ...
    }:
    let
      pkgs = inputs'.nixpkgs-unstable.legacyPackages;
    in
    {
      devShells = {
        ci = pkgs.callPackage ./ci.nix { inherit inputs; };
        default = pkgs.callPackage ./default.nix { };

        c = pkgs.callPackage ./c.nix { };
        elixir = pkgs.callPackage ./elixir.nix { };
        go = pkgs.callPackage ./go.nix { };
        js = pkgs.callPackage ./js.nix { };
        nixpkgs = pkgs.callPackage ./nixpkgs.nix { };
        ocaml = pkgs.callPackage ./ocaml.nix { inherit inputs; };
        python = pkgs.callPackage ./python.nix { };
        rust = pkgs.callPackage ./rust.nix { };
        zig = pkgs.callPackage ./zig.nix { };
      };
    };
}
