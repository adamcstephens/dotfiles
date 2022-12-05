{
  emacs,
  nixpkgs,
  ...
}: rec {
  default = nixpkgs.lib.composeManyExtensions [
    emacs.overlays.emacs
    emacs.overlays.package
    gtklock
    fishPlugins
    terminfo
    wob
  ];

  gtklock = _: prev: {gtklock = prev.callPackage ./packages/gtklock.nix {};};
  terminfo = _: prev: {terminfo = prev.callPackage ./packages/terminfo {};};

  # disable tests since they broke on darwin...
  fishPlugins = _: prev: {
    fishPlugins = prev.fishPlugins.overrideScope' (_: fprev: {
      fzf-fish = fprev.fzf-fish.overrideAttrs (_: {
        doCheck = false;
      });
    });
  };

  wob = _: prev: {
    wob = prev.wob.overrideAttrs (pprev: {
      version = "0.14";
      src = prev.fetchFromGitHub {
        owner = "francma";
        repo = "wob";
        rev = "0.14";
        sha256 = "sha256-lZlzWXZwmuD8G/PUC94HhJsRBM17O+f8ffOD6s1mHXI=";
      };
      buildInputs = [prev.inih] ++ pprev.buildInputs;
    });
  };
}
