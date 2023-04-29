{inputs, ...}: {
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
  ];

  perSystem = {system, ...}: {
    overlayAttrs = {
      gtklock = inputs.nixpkgs-unstable.legacyPackages.${system}.gtklock;
      webcord = inputs.nixpkgs-unstable.legacyPackages.${system}.webcord;
    };
  };

  flake.overlays = rec {
    upstreams = inputs.nixpkgs.lib.composeManyExtensions [
      inputs.emacs-overlay.overlays.emacs
      inputs.emacs-overlay.overlays.package
      fishPlugins
    ];

    # disable tests since they broke on darwin...
    fishPlugins = _: prev: {
      fishPlugins = prev.fishPlugins.overrideScope' (_: fprev: {
        fzf-fish = fprev.fzf-fish.overrideAttrs (_: {
          doCheck = false;
        });
      });
    };
  };
}
