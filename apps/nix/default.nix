{
  config,
  ...
}:

{
  nix.gc = {
    automatic = !config.dotfiles.nixosManaged;
    frequency = "weekly";
    options = "--delete-older-than +30d";
  };
}
