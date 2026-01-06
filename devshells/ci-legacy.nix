{
  inputs,
  pkgs,
  mkShellNoCC,
}:
mkShellNoCC {
  name = "ci-legacy";
  packages = [
    pkgs.attic-client
    pkgs.git
    pkgs.just
    pkgs.ntfy-sh
    inputs.sower.packages.${pkgs.stdenv.hostPlatform.system}.seed-ci
    inputs.sower.packages.${pkgs.stdenv.hostPlatform.system}.client
  ];
}
