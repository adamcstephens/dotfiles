{ inputs, withSystem, ... }:
{
  flake.devShells.aarch64-linux = withSystem "aarch64-linux" (
    { inputs', pkgs, ... }:
    {
      incus = import ./incus.nix { pkgs = inputs'.nixpkgs-unstable.legacyPackages; };
    }
  );

  flake.devShells.x86_64-linux = withSystem "x86_64-linux" (
    { inputs', pkgs, ... }:
    {
      distrobuilder = import ./distrobuilder.nix { pkgs = inputs'.nixpkgs-unstable.legacyPackages; };
      incus = import ./incus.nix { pkgs = inputs'.nixpkgs-unstable.legacyPackages; };

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
      inputs',
      pkgs,
      self',
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
            pkgs.nix-update
            pkgs.npins
            pkgs.nushell
          ];
        };

        default = pkgs.mkShellNoCC {
          name = "dots";
          packages = [
            # local only
            pkgs.attic-client
            pkgs.pyright
          ] ++ self'.devShells.ci.nativeBuildInputs;
        };

        elixir = inputs'.nixpkgs-unstable.legacyPackages.callPackage ./elixir.nix { };
        go = inputs'.nixpkgs-unstable.legacyPackages.callPackage ./go.nix { };
        nixpkgs = inputs'.nixpkgs-unstable.legacyPackages.callPackage ./nixpkgs.nix { };
        python = inputs'.nixpkgs-unstable.legacyPackages.callPackage ./python.nix { };
        rust = inputs'.nixpkgs-unstable.legacyPackages.callPackage ./rust.nix { };
        zig = inputs'.nixpkgs-unstable.legacyPackages.callPackage ./zig.nix { };

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

        vscode = pkgs.mkShellNoCC { packages = [ pkgs.vsce ] ++ self'.devShells.js.nativeBuildInputs; };
      };
    };
}
