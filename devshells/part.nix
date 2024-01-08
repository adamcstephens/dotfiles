{ inputs, withSystem, ... }:
{
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
          (pkgs.ghc.withPackages (
            ps: [
              ps.haskell-language-server
              ps.ormolu
              ps.xmonad
              ps.xmonad-contrib
            ]
          ))
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
        default = pkgs.mkShellNoCC {
          name = "dots";
          packages = [
            (inputs.attic.packages.${pkgs.system}.attic.overrideAttrs (
              prev: {
                env =
                  lib.optionalAttrs pkgs.stdenv.cc.isClang {
                    NIX_LDFLAGS = "-l${pkgs.stdenv.cc.libcxx.cxxabi.libName}";
                  }
                  // (prev.env or { });
              }
            ))
            pkgs.curl
            pkgs.deadnix
            pkgs.git-subrepo
            pkgs.just
            inputs.nil.packages.${pkgs.system}.nil
            pkgs.nix-eval-jobs
            pkgs.nodePackages.prettier
            pkgs.npins
            pkgs.nushell
            pkgs.nvd
          ];
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

        go = pkgs.mkShell {
          packages = [
            pkgs.delve
            pkgs.go
            pkgs.golangci-lint
            pkgs.gopls
            pkgs.go-tools
            pkgs.gotools
            pkgs.gnumake

            pkgs.pkg-config
            pkgs.pcsclite
          ];

          shellHook = ''
            export CGO_ENABLED=1
          '';
        };

        js = pkgs.mkShellNoCC {
          packages = [
            pkgs.esbuild
            pkgs.nodejs
            pkgs.yarn
          ];
        };

        nixpkgs = pkgs.mkShellNoCC {
          name = "nixpkgs-devshell";
          packages = [
            pkgs.nixVersions.nix_2_16
            pkgs.nix-bisect
            pkgs.nix-generate-from-cpan
            pkgs.nix-prefetch-github
            pkgs.nix-prefetch-scripts
            pkgs.nix-tree
            pkgs.nix-update
            pkgs.nixpkgs-fmt
            pkgs.nixpkgs-review
            pkgs.deadnix
          ] ++ (lib.optionals pkgs.stdenv.isLinux [ pkgs.bubblewrap ]);

          shellHook = ''
            ln -sf $HOME/.dotfiles/apps/nix/dir-locals.el $PWD/.dir-locals.el
            ln -sfT $HOME/.dotfiles/apps/nix/vscode $PWD/.vscode
            ln -sfT $HOME/.dotfiles/apps/nix/vscode $PWD/.vscodium
            ln -sfT $HOME/.dotfiles/apps/nix/helix $PWD/.helix

            if [ -d .git ]; then
              mkdir -vp $PWD/.git/info
              ln -sf $HOME/.dotfiles/apps/nix/exclude $PWD/.git/info/exclude
            fi
          '';
        };

        opentofu = pkgs.mkShellNoCC { packages = [ pkgs.opentofu ]; };

        python = pkgs.mkShellNoCC {
          packages = [
            (pkgs.python3.withPackages (
              py: [
                py.black
                py.hexdump
                py.paramiko
              ]
            ))
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
