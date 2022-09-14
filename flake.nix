{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs.follows = "nixpkgs";
    nil.url = "github:oxalica/nil";
    nil.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    webcord.url = "github:fufexan/webcord-flake";
    webcord.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit self;} {
      imports = [
        ./nix/homes.nix
      ];

      systems = ["x86_64-linux" "aarch64-darwin"];

      perSystem = {pkgs, ...}: {
        apps.update-home = {
          type = "app";
          program =
            (pkgs.writeScript "update-home" ''
              echo "building new profile"
              nix build --no-link .#homeConfigurations.$USER.activationPackage

              old_profile=$(nix profile list | grep home-manager-path | head -n1 | awk '{print $4}')
              if [ -n "$old_profile" ]; then
                echo "removing old profile: $old_profile"
                nix profile remove $old_profile
              fi

              echo "activating new profile"
              if ! "$(nix path-info .#homeConfigurations.$USER.activationPackage)"/activate; then
                echo "restoring old profile $old_profile"
                nix profile install $old_profile
              fi
            '')
            .outPath;
        };

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.earthly
          ];
        };
      };
    };
}
