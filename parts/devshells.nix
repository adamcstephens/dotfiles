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
        packages = [
          pkgs.alejandra
          pkgs.babashka
          inputs.sandbox.packages.${pkgs.system}.cljfmt
          pkgs.curl
          pkgs.deadnix
          pkgs.git-subrepo
          pkgs.just
          inputs.nil.packages.${pkgs.system}.nil
          pkgs.nodePackages.prettier
          pkgs.nvd
        ];
      };
      elixir = pkgs.mkShell {
        packages = [
          pkgs.elixir
          pkgs.elixir-ls
          pkgs.inotify-tools
        ];
      };
      go = pkgs.mkShell {
        packages = [
          pkgs.delve
          pkgs.go
          pkgs.golangci-lint
          pkgs.gopls
          pkgs.go-tools
          pkgs.gotools
        ];

        shellHook = ''
          export CGO_ENABLED=1
        '';
      };
      kmonad = pkgs.mkShell {
        name = "kmonad";
        packages =
          if pkgs.stdenv.hostPlatform.isDarwin
          then [
            (inputs.kmonad.packages.${system}.kmonad.overrideAttrs (prev: {
              patches = [../apps/kmonad/m2.patch];
            }))
            inputs.kmonad.packages.${system}.list-keyboards
          ]
          else [inputs.kmonad.packages.${system}.kmonad];
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
            pkgs.nix-index
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
          (pkgs.python3.withPackages (py: [py.black py.hexdump py.paramiko]))
        ];
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
    };
  };
}
