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

        elixir = pkgs.callPackage ./elixir.nix { };
        go = pkgs.callPackage ./go.nix { };
        nixpkgs = pkgs.callPackage ./nixpkgs.nix { };
        python = pkgs.callPackage ./python.nix { };
        zig = pkgs.callPackage ./zig.nix { };

        # inline

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

        js = pkgs.mkShellNoCC {
          packages = [
            pkgs.esbuild
            pkgs.nodejs
            pkgs.yarn
          ];
        };

        opentofu = pkgs.mkShellNoCC { packages = [ pkgs.opentofu ]; };

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
