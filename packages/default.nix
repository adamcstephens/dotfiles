{
  pkgs,
  homeConfigurations,
  inputs,
  ...
}: rec {
  arkenfox = pkgs.callPackage ./arkenfox {};
  hm = pkgs.callPackage ./hm.nix {
    inherit home-profile-selector;
    inherit (inputs.nh.packages.${pkgs.system}) nh;
  };
  hm-all = pkgs.callPackage ./hm-all.nix {
    inherit homeConfigurations;
  };
  home-profile-selector = pkgs.callPackage ./home-profile-selector.nix {
    inherit homeConfigurations;
  };
  revealjs = pkgs.callPackage ../apps/emacs/revealjs.nix {};
}
