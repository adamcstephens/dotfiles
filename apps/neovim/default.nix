{
  config,
  lib,
  pkgs,
  flake,
  ...
}:
let
  cfg = config.dotfiles.apps.neovim;

  package = flake.packages.${pkgs.stdenv.hostPlatform.system}.neovim.override {
    inherit (cfg) full;
    dotvimPlugin =
      if config.dotfiles.nixosManaged then ./. else "${config.directory}/.dotfiles/apps/neovim";
  };
in
{
  options.dotfiles.apps.neovim.full =
    lib.mkEnableOption "install the full set of tools, as if a workstation";

  config = {
    environment.sessionVariables = {
      MANPAGER = "nvim +Man!";
      MANWIDTH = "999";
    };

    packages = [ package ];
  };
}
