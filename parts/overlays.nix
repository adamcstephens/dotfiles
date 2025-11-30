{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.easyOverlay ];

  flake.overlays = {
    dotfiles = _: prev: { };
  };
}
