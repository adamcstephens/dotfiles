{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];

      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        { pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.just

              pkgs.cargo
              pkgs.clippy
              pkgs.rustc
              pkgs.rust-analyzer
              pkgs.rustfmt
            ];
          };

          packages.default = pkgs.callPackage ./nix/package.nix { };
        };
    };
}
