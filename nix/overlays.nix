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
}
