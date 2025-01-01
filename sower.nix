{ ... }:
{
  imports = [
    ./sowerjobs.nix
  ];

  perSystem =
    {
      self',
      ...
    }:
    {
      sowerJobs = self'.packages;
    };
}
