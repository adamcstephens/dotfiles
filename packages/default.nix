{
  pkgs,
  homeConfigurations,
  ...
}: rec {
  arkenfox-patch = pkgs.callPackage ./arkenfox-patch.nix {
    arkenfoxSrc = pkgs.fetchFromGitHub {
      owner = "arkenfox";
      repo = "user.js";
      rev = "115.0";
      hash = "sha256-knJa1zI27NsKGwpps3MMrG9K7HDGCDnoRfm16pNR/yM=";
    };
  };
  hm = pkgs.callPackage ./hm.nix {
    inherit home-profile-selector;
  };
  hm-all = pkgs.callPackage ./hm-all.nix {
    inherit homeConfigurations;
  };
  home-profile-selector = pkgs.callPackage ./home-profile-selector.nix {
    inherit homeConfigurations;
  };
  revealjs = pkgs.callPackage ../apps/emacs/revealjs.nix {};
  terminfo = pkgs.callPackage ./terminfo {};
}
