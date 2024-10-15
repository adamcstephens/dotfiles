{
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
    ../apps/jujutsu
    ../apps/kitty
    ../apps/ssh
    ../apps/vscode
    ../apps/vscodium
  ];

  dotfiles = {
    apps = {
      emacs = {
        package = lib.mkDefault pkgs.emacs29;
        patchForGui = lib.mkDefault false;
        full = lib.mkDefault true;
      };
      neovim.full = true;
      vscodium.enable = lib.mkDefault true;
    };

    gui.enable = true;
  };

  home.packages = [
    # crypt
    pkgs.age-plugin-yubikey
    pkgs.passage
    pkgs.rage
    pkgs.rbw
    pkgs.yubikey-manager

    # nix
    pkgs.nix-output-monitor
    pkgs.nix-tree
    pkgs.nixd
    pkgs.nixfmt-rfc-style

    # tools
    pkgs.pwgen
    pkgs.restish
    pkgs.unzip

    # apps
    pkgs.eternal-terminal
    pkgs.senpai
  ];

  programs = {
    ssh.forwardAgent = true;
  };
}
