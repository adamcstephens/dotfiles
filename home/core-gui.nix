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
    ../apps/vscode
    ../apps/vscodium
  ];

  dotfiles = {
    apps = {
      vscodium.enable = lib.mkDefault false;
    };

    gui.enable = true;
  };

  home.packages = [
    inputs.nixpkgs-unstable-small.legacyPackages.${pkgs.system}.age-plugin-yubikey
    inputs.nixpkgs-unstable-small.legacyPackages.${pkgs.system}.yubikey-manager
  ];
}
