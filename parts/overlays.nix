{inputs, ...}: {
  flake.overlays = rec {
    default = inputs.nixpkgs.lib.composeManyExtensions [
      inputs.emacs.overlays.emacs
      inputs.emacs.overlays.package
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
