{
  pkgs,
  homeConfigurations,
  inputs,
  lib,
  ...
}:
rec {
  arkenfox = pkgs.callPackage ./arkenfox { };
  hm = pkgs.callPackage ./hm.nix { inherit home-profile-selector; };
  hm-all = pkgs.callPackage ./hm-all.nix { inherit homeConfigurations; };
  home-profile-selector = pkgs.callPackage ./home-profile-selector.nix {
    inherit homeConfigurations;
  };
  revealjs = pkgs.callPackage ../apps/emacs/revealjs.nix { };

  seed-ci =
    pkgs.runCommandNoCC "seed-ci"
      {
        nativeBuildInputs = [ pkgs.makeWrapper ];
        buildInputs = [ pkgs.nushell ];
      }
      ''
        mkdir -p $out/bin
        cp ${../bin/seed-ci} $out/bin/seed-ci
        patchShebangs $out/bin

        wrapProgram $out/bin/seed-ci --prefix PATH : ${
          lib.makeBinPath [
            inputs.attic.packages.${pkgs.system}.attic
            pkgs.coreutils
            pkgs.nix
            pkgs.nix-eval-jobs
          ]
        }
      '';
}
