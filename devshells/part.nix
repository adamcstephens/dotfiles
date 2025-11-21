{ inputs, withSystem, ... }:
{
  flake.devShells.x86_64-linux = withSystem "x86_64-linux" (
    { inputs', ... }:
    let
      pkgs = inputs'.nixpkgs-unstable.legacyPackages;
    in
    {
      distrobuilder = pkgs.callPackage ./distrobuilder.nix { };
      # incus = pkgs.callPackage ./incus.nix { };
      xmonad = pkgs.callPackage ./xmonad.nix { };
    }
  );

  perSystem =
    {
      pkgs-unstable,
      system,
      ...
    }:
    let
      # use unstable for devshells
      pkgs = pkgs-unstable;

      npins = import ../npins;
    in
    {
      _module.args = {
        inherit npins;

        # lix overlay for flake-parts
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            (import "${npins.lix-nixos-module}/overlay.nix" {
              # use nixpkgs lix
              lix = npins.lix;
            })
          ];
        };
        pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit system;
          overlays = [
            (import "${npins.lix-nixos-module}/overlay.nix" {
              # use nixpkgs lix
              lix = npins.lix;
            })
          ];
        };
      };

      devShells = {
        cd = pkgs.callPackage ./cd.nix { };
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
