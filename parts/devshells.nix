{inputs, ...}: {
  perSystem = {
    lib,
    pkgs,
    system,
    ...
  }: {
    devShells = {
      default = pkgs.mkShellNoCC {
        name = "dots";
        packages =
          [
            pkgs.alejandra
            pkgs.deadnix
            pkgs.git-subrepo
            pkgs.just
            inputs.nil.packages.${pkgs.system}.nil
            pkgs.nodePackages.prettier
          ]
          ++ (lib.optionals pkgs.stdenv.isLinux
            [
              (pkgs.ghc.withPackages (ps: [
                ps.haskell-language-server
                ps.ormolu
                ps.xmonad
                ps.xmonad-contrib
              ]))
            ]);
      };
      go = pkgs.mkShell {
        packages = [
          pkgs.go
          pkgs.gopls
        ];
      };
      kmonad = pkgs.mkShell {
        name = "kmonad";
        packages = [
          (inputs.kmonad.packages.${system}.kmonad.overrideAttrs (prev: {
            patches = [../apps/kmonad/m2.patch];
          }))
          inputs.kmonad.packages.${system}.list-keyboards
        ];
      };
      media = pkgs.mkShellNoCC {
        name = "media";
        packages = [
          pkgs.ffmpeg_5-full
        ];
      };
      nixpkgs = pkgs.mkShellNoCC {
        packages =
          [
            pkgs.nix-update
            pkgs.nixpkgs-review
            pkgs.deadnix
          ]
          ++ (lib.optionals pkgs.stdenv.isLinux [
            pkgs.bubblewrap
          ]);
      };
      python = pkgs.mkShellNoCC {
        packages = [
          (pkgs.python3.withPackages (py: [py.hexdump py.paramiko]))
        ];
      };
    };
  };
}
