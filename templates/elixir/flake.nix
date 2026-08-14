{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
          beamPackages = pkgs.beamMinimal27Packages.extend (
            _: prev: {
              elixir = prev.elixir_1_18;
            }
          );
        in
        {
          devShells.default = pkgs.mkShell {
            packages = [
              beamPackages.erlang
              beamPackages.elixir
              beamPackages.elixir-ls
              beamPackages.hex
              beamPackages.rebar3
            ]
            ++ (lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.inotify-tools ]);

            shellHook = ''
              export ERL_AFLAGS="-kernel shell_history enabled -kernel shell_history_file_bytes 1024000"
            '';
          };
        };
    };
}
