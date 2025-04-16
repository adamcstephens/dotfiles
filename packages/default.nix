{
  inputs,
  pkgs,
  homeConfigurations,
  ...
}:
rec {
  arkenfox = pkgs.callPackage ./arkenfox { };
  dotfiles = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.callPackage ./dotfiles.nix (
    if pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64 then
      {
        ocamlPackages =
          inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.pkgsMusl.ocaml-ng.ocamlPackages_5_3;
      }
    else
      {
        ocamlPackages = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.ocaml-ng.ocamlPackages_5_3;
        static = false;
      }
  );
  hm = pkgs.callPackage ./hm.nix { inherit home-profile-selector; };
  home-profile-selector = pkgs.callPackage ./home-profile-selector.nix {
    inherit homeConfigurations;
  };
  prj = pkgs.callPackage ./prj.nix { };
  rofi-wrapper = pkgs.callPackage ./rofi-wrapper.nix { };
  vim-zellij-navigator = pkgs.callPackage ./vim-zellij-navigator.nix { };
}
