{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.easyOverlay ];

  flake.overlays = rec {
    dotfiles = _: prev: { };

    upstreams = inputs.nixpkgs.lib.composeManyExtensions [ fishPlugins ];

    # disable tests since they broke on darwin...
    fishPlugins = _: prev: {
      fishPlugins = prev.fishPlugins.overrideScope (
        _: fprev: {
          fzf-fish = fprev.fzf-fish.overrideAttrs (_: {
            doCheck = false;
          });
          pure = fprev.pure.overrideAttrs (_: {
            doCheck = false;
          });
        }
      );
    };
  };
}
