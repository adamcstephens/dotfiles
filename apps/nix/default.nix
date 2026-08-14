{
  config,
  pkgs,
  ...
}:

{
  nix.gc = {
    automatic = !config.dotfiles.nixosManaged && !pkgs.stdenv.hostPlatform.isDarwin;
    dates = "weekly";
    options = "--delete-older-than +30d";
  };
}
