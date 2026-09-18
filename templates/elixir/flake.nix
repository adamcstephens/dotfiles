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
        { lib, pkgs, ... }:
        let
          beamPackages = pkgs.beamMinimal29Packages.extend (
            _: prev: {
              elixir = prev.elixir_1_20;
            }
          );
        in
        {
          devShells.default = pkgs.mkShell {
            packages = [
              beamPackages.erlang
              beamPackages.elixir
              beamPackages.expert
              beamPackages.hex
              beamPackages.rebar3
              pkgs.dexter
            ]
            ++ (lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.inotify-tools ]);

            shellHook = ''
              export ERL_AFLAGS="-kernel shell_history enabled -kernel shell_history_file_bytes 1024000"
            '';
          };
        };
    };
}
