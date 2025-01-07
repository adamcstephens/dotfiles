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

      xmonad = pkgs.mkShellNoCC {
        packages = [
          (pkgs.ghc.withPackages (ps: [
            ps.haskell-language-server
            ps.ormolu
            ps.xmonad
            ps.xmonad-contrib
          ]))
        ];
      };
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
        ci = pkgs.mkShellNoCC {
          name = "ci";
          packages = [
            inputs.sower.packages.${pkgs.system}.seed-ci
            inputs.sower.packages.${pkgs.system}.client

            pkgs.git
            pkgs.just
            pkgs.nix-update
            pkgs.npins
            pkgs.nushell
          ];
        };

        default = pkgs.mkShellNoCC {
          name = "dots";
          packages = [
            # local only
            pkgs.attic-client
          ] ++ self'.devShells.ci.nativeBuildInputs;
        };

        c = pkgs.callPackage ./c.nix { };
        elixir = pkgs.callPackage ./elixir.nix { };
        go = pkgs.callPackage ./go.nix { };
        js = pkgs.callPackage ./js.nix { };
        nixpkgs = pkgs.callPackage ./nixpkgs.nix { };
        ocaml = pkgs.callPackage ./ocaml.nix { };
        python = pkgs.callPackage ./python.nix { };
        rust = pkgs.callPackage ./rust.nix { };
        zig = pkgs.callPackage ./zig.nix { };
        vscode = pkgs.callPackage ./vscode.nix {
          devShells = self'.devShells;
        };
      };
    };
}
