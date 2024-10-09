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
    ../apps/vscode
    ../apps/vscodium
  ];

  dotfiles.apps = {
    emacs = {
      package = lib.mkDefault pkgs.emacs29;
      patchForGui = lib.mkDefault false;
      full = lib.mkDefault true;
    };
    neovim.full = true;
    vscodium.enable = lib.mkDefault true;
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

    # dev
    pkgs.gh
    pkgs.hut
    pkgs.lazygit
    (pkgs.writeShellScriptBin "lg" "exec ${lib.getExe pkgs.lazygit} $@")
    pkgs.tea
  ];

  programs = {
    ssh.forwardAgent = true;
  };
}
