{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-darwin"];
      perSystem = {pkgs, ...}: {
        devShells.default = pkgs.mkShellNoCC {
          packages = [
            pkgs.nixpkgs-review
          ];
        };
      };
    };
}
