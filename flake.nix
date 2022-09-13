{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-22.05-darwin";
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    webcord.url = "github:fufexan/webcord-flake";
    webcord.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    darwin,
    home-manager,
    ...
  }: let
    pkgs-darwin = nixpkgs.legacyPackages.aarch64-darwin;
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in {
    apps.x86_64-linux.update-home = {
      type = "app";
      program =
        (nixpkgs.legacyPackages.x86_64-linux.writeScript "update-home" ''
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

    apps.aarch64-darwin.update-home = {
      type = "app";
      program =
        (nixpkgs.legacyPackages.aarch64-darwin.writeScript "update-home" ''
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

    devShells.x86_64-linux.default = pkgs.mkShell {
      nativeBuildInputs = [
        pkgs.alejandra
      ];
    };

    homeConfigurations.adam = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        (_: {
          home.username = "adam";
          home.homeDirectory = "/home/adam";
        })
        ./nix/home.nix
      ];
    };

    homeConfigurations.astephe9 = home-manager.lib.homeManagerConfiguration {
      pkgs = pkgs-darwin;

      modules = [
        (_: {
          home.username = "astephe9";
          home.homeDirectory = "/Users/astephe9";
        })
        ./nix/home.nix
      ];
    };
  };
}
