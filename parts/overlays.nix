{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.easyOverlay ];

  flake.overlays = rec {
    upstreams = inputs.nixpkgs.lib.composeManyExtensions [ fishPlugins ];

    # disable tests since they broke on darwin...
    fishPlugins = _: prev: {
      fishPlugins = prev.fishPlugins.overrideScope' (
        _: fprev: { fzf-fish = fprev.fzf-fish.overrideAttrs (_: { doCheck = false; }); }
      );
    };
  };
}
