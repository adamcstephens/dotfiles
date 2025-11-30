{
  config,
  pkgs,
  ...
}:

{
  nix.gc = {
    automatic = !config.dotfiles.nixosManaged && !pkgs.stdenv.isDarwin;
    dates = "weekly";
    options = "--delete-older-than +30d";
  };
}
