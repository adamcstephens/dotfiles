{perSystem, ...}: {
  perSystem = {
    lib,
    pkgs,
    ...
  }: {
    devShells = {
      default = pkgs.mkShellNoCC {
        name = "dots";
        packages =
          [
            pkgs.alejandra
            pkgs.deadnix
            pkgs.just
            pkgs.nil
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
      miryoku_kmonad = pkgs.mkShell {
        name = "miryoku_kmonad";
        packages = [
          pkgs.gnumake
          pkgs.gnused
        ];
      };
      nixpkgs = pkgs.mkShellNoCC {
        packages =
          [
            pkgs.nixpkgs-review
            pkgs.deadnix
          ]
          ++ (lib.optionals pkgs.stdenv.isLinux [
            pkgs.bubblewrap
          ]);
      };
    };
  };
}
