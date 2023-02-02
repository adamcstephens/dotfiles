{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-darwin" "aarch64-linux"];
      perSystem = {
        pkgs,
        lib,
        ...
      }: {
        devShells.default = pkgs.mkShellNoCC {
          packages =
            [
              pkgs.nixpkgs-review
              pkgs.deadnix
            ]
            ++ (lib.optionals pkgs.stdenv.isLinux [
              pkgs.bubblewrap
            ]);
        };
      };
    };
}
