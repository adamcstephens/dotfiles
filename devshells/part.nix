{ inputs, withSystem, ... }:
{
  flake.devShells.aarch64-linux = withSystem "aarch64-linux" (
    { pkgs, ... }:
    {
      incus = import ./incus.nix { inherit pkgs; };
    }
  );

  flake.devShells.x86_64-linux = withSystem "x86_64-linux" (
    { pkgs, ... }:
    {
      distrobuilder = import ./distrobuilder.nix { inherit pkgs; };
      incus = import ./incus.nix { inherit pkgs; };

      media = pkgs.mkShellNoCC {
        name = "media";
        packages = [ pkgs.ffmpeg_5-full ];
      };

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
      lib,
      pkgs,
      self',
      system,
      ...
    }:
    {
      devShells = {
        ci = pkgs.mkShellNoCC {
          name = "ci";
          packages = [
            inputs.sower.packages.${pkgs.system}.seed-ci

            pkgs.git
            pkgs.just
            pkgs.npins
            pkgs.nushell
          ];
        };

        default = pkgs.mkShellNoCC {
          name = "dots";
          packages = [
            # local only
            inputs.attic.packages.${pkgs.system}.attic
          ] ++ self'.devShells.ci.nativeBuildInputs;
        };

        c = pkgs.mkShell {
          packages = [
            pkgs.autoconf
            pkgs.automake
            pkgs.binutils
            pkgs.cmake
            pkgs.gnumake
            pkgs.gcc
            pkgs.libtool
            pkgs.meson
            pkgs.ninja
            pkgs.mtools
            pkgs.perl
            pkgs.xz
          ];
        };

        elixir = pkgs.mkShell {
          packages = [
            pkgs.pkgs.beam.packages.erlangR25.elixir_1_15
            pkgs.pkgs.beam.packages.erlangR25.elixir-ls
          ] ++ (lib.optionals pkgs.stdenv.isLinux [ pkgs.inotify-tools ]);

          shellHook = ''
            export ERL_AFLAGS="-kernel shell_history enabled -kernel shell_history_file_bytes 1024000"
          '';
        };

        go = pkgs.callPackage ./go.nix { };

        js = pkgs.mkShellNoCC {
          packages = [
            pkgs.esbuild
            pkgs.nodejs
            pkgs.yarn
          ];
        };

        nixpkgs = pkgs.callPackage ./nixpkgs.nix { };

        opentofu = pkgs.mkShellNoCC { packages = [ pkgs.opentofu ]; };

        python = pkgs.mkShellNoCC {
          packages = [
            (pkgs.python3.withPackages (py: [
              py.black
              py.hexdump
              py.paramiko
            ]))
          ];
        };

        rust = pkgs.mkShell {
          packages = [
            pkgs.cargo
            pkgs.openssl.dev
            pkgs.pkg-config
            pkgs.rustc
            pkgs.rust-analyzer
          ];
        };

        vscode = pkgs.mkShellNoCC { packages = [ pkgs.vsce ] ++ self'.devShells.js.nativeBuildInputs; };
      };
    };
}
