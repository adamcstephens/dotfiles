{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./colors.nix
    ./core-dev.nix

    ../apps/ghostty
    ../apps/kitty
  ];

  dotfiles = {
    gui.enable = true;
  };

  home.packages = [
    inputs.nixpkgs-unstable-small.legacyPackages.${pkgs.system}.age-plugin-yubikey
    inputs.nixpkgs-unstable-small.legacyPackages.${pkgs.system}.yubikey-manager
  ];
}
