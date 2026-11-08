{ pkgs, ... }:
{
  imports = [
    ./colors.nix
    ../apps/ghostty
    ../apps/kitty
  ];

  dotfiles = {
    gui.enable = true;
  };

  home.packages = [
    pkgs.age-plugin-yubikey
    pkgs.yubikey-manager

    # dev tools
    pkgs.meld
    pkgs.paseo-desktop
  ];
}
