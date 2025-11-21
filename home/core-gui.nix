{
  pkgs,
  ...
}:
{
  imports = [
    ./colors.nix
    ./core-dev.nix

    ../apps/display-switch
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
  ];
}
