{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./colors.nix

    ../apps/atuin
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
    pkgs.rbw
    pkgs.yubikey-manager

    # nix
    inputs.nix-index-database.packages.${pkgs.system}.comma-with-db
    pkgs.nix-output-monitor
    pkgs.nix-tree
    pkgs.nixfmt-rfc-style

    # tools
    pkgs.pwgen
    pkgs.unzip

    # apps
    pkgs.eternal-terminal
    pkgs.senpai
  ];

  programs = {
    ssh.forwardAgent = true;
  };
}
