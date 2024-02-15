{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./colors.nix

    ../apps/emacs
    ../apps/ghostty
    ../apps/kitty
    ../apps/ssh
    ../apps/vscodium
  ];

  dotfiles.apps.emacs = {
    package = lib.mkDefault pkgs.emacs29;
    patchForGui = lib.mkDefault false;
    full = lib.mkDefault true;
  };

  home.packages = [
    # crypt
    pkgs.age-plugin-yubikey
    pkgs.passage
    pkgs.rage
    pkgs.yubikey-manager

    # nix
    inputs.nil.packages.${pkgs.system}.nil
    inputs.nix-index-database.packages.${pkgs.system}.comma-with-db
    pkgs.nix-output-monitor
    pkgs.nixfmt-rfc-style

    # tools
    pkgs.pwgen
    pkgs.unzip

    # apps
    pkgs.senpai
    pkgs.spotify
  ];

  programs = {
    ssh.forwardAgent = true;
  };
}
