{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    emacs.url = "github:nix-community/emacs-overlay";
    emacs.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs.follows = "nixpkgs";
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
      flake.overlays = [(import self.inputs.emacs-overlay)];

      imports = [
        ./nix/homes.nix
      ];

      systems = ["x86_64-linux" "aarch64-darwin"];

      perSystem = {pkgs, ...}: {
        apps.update-home = {
          type = "app";
          program =
            (pkgs.writeScript "update-home" ''
              HMPROFILE="$USER-${pkgs.stdenv.hostPlatform.system}"

              echo "building new profile"
              nix --extra-experimental-features "nix-command flakes" build --no-link .#homeConfigurations.$HMPROFILE.activationPackage || exit 1

              old_profile=$(nix --extra-experimental-features "nix-command flakes" profile list | grep home-manager-path | head -n1 | awk '{print $4}')
              if [ -n "$old_profile" ]; then
                echo "removing old profile: $old_profile"
                nix --extra-experimental-features "nix-command flakes" profile remove $old_profile
              fi

              echo "activating new profile"
              if ! "$(nix --extra-experimental-features "nix-command flakes" path-info .#homeConfigurations.$HMPROFILE.activationPackage)"/activate; then
                echo "restoring old profile $old_profile"
                nix --extra-experimental-features "nix-command flakes" profile install $old_profile
              fi
            '')
            .outPath;
        };

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.earthly
            pkgs.python3Minimal
          ];
        };
      };
    };
}
