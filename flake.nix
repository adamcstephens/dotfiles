{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    doom-emacs.url = "github:nix-community/nix-doom-emacs";
    doom-emacs.inputs.nixpkgs.follows = "nixpkgs";
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
      imports = [
        ./nix/homes.nix
      ];

      systems = ["x86_64-linux" "aarch64-darwin"];

      perSystem = {
        pkgs,
        system,
        ...
      }: {
        _module.args.pkgs = import self.inputs.nixpkgs {
          inherit system;
          overlays = [self.inputs.emacs.overlay];
        };

        apps = let
          nixCmd = ''nix --extra-experimental-features "nix-command flakes"'';
        in {
          hm-build = {
            type = "app";
            program =
              (
                pkgs.writeScript "hm-build" ''
                  HMPROFILE="$USER-${pkgs.stdenv.hostPlatform.system}"

                  echo "building new profile"
                  ${nixCmd} build --no-link .#homeConfigurations.$HMPROFILE.activationPackage || exit 1
                ''
              )
              .outPath;
          };
          hm-switch = {
            type = "app";
            program =
              (pkgs.writeScript "hm-update" ''
                HMPROFILE="$USER-${pkgs.stdenv.hostPlatform.system}"

                echo "building new profile"
                ${nixCmd} build --no-link .#homeConfigurations.$HMPROFILE.activationPackage || exit 1

                old_profile=$(${nixCmd} profile list | grep home-manager-path | head -n1 | awk '{print $4}')
                if [ -n "$old_profile" ]; then
                  echo "removing old profile: $old_profile"
                  ${nixCmd} profile remove $old_profile
                fi

                echo "activating new profile"
                if ! "$(${nixCmd} path-info .#homeConfigurations.$HMPROFILE.activationPackage)"/activate; then
                  echo "restoring old profile $old_profile"
                  ${nixCmd} profile install $old_profile
                fi
              '')
              .outPath;
          };
        };

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.cachix
            pkgs.earthly
            pkgs.python3Minimal
          ];
        };
      };
    };
}
