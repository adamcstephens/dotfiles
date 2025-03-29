{
  config,
  ...
}:

{
  nix.gc = {
    automatic = !config.dotfiles.nixosManaged;
    frequency = "weekly";
  };
}
