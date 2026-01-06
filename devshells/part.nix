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
      inputs',
      pkgs-unstable,
      system,
      ...
    }:
    let
      npins = import ../npins;
    in
    {
      _module.args =
        if (system == "x86_64-linux") then
          {
            inherit npins;

            # lix overlay for flake-parts
            pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [
                (import "${npins.lix-nixos-module}/overlay.nix" {
                  # use nixpkgs lix matching version from module
                  lix = null;
                })
              ];
            };
            pkgs-unstable = import inputs.nixpkgs-unstable {
              inherit system;
              overlays = [
                (import "${npins.lix-nixos-module}/overlay.nix" {
                  # use nixpkgs lix matching version from module
                  lix = null;
                })
              ];
            };
          }
        else
          {
            inherit npins;
            pkgs-unstable = inputs'.nixpkgs-unstable.legacyPackages;
          };

      devShells = {
        cd = pkgs-unstable.callPackage ./cd.nix { };
        ci = pkgs-unstable.callPackage ./ci.nix { inherit inputs; };
        ci-legacy = pkgs-unstable.callPackage ./ci-legacy.nix { inherit inputs; };
        default = pkgs-unstable.callPackage ./default.nix { inherit inputs; };

        c = pkgs-unstable.callPackage ./c.nix { };
        elixir = pkgs-unstable.callPackage ./elixir.nix { };
        go = pkgs-unstable.callPackage ./go.nix { };
        js = pkgs-unstable.callPackage ./js.nix { };
        nixpkgs = pkgs-unstable.callPackage ./nixpkgs.nix { };
        ocaml = pkgs-unstable.callPackage ./ocaml.nix { inherit inputs; };
        python = pkgs-unstable.callPackage ./python.nix { };
        rust = pkgs-unstable.callPackage ./rust.nix { };
        zig = pkgs-unstable.callPackage ./zig.nix { };
      };
    };
}
