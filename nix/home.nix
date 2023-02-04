{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../apps/fish
    ../apps/lsd
    ../apps/zsh
  ];

  home.stateVersion = "22.05";

  programs.home-manager.enable = true;

  home.activation.dotfiles-migrate = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    if [ -d ~/.dotfiles ]; then
      pushd ~/.dotfiles
        if [ -e .nixos-managed ]; then
          git pull
        fi
        ${pkgs.just}/bin/just migrate
      popd
    fi
  '';

  home.activation.dotfiles-bootstrap = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH=${config.home.path}/bin:${config.home.path}/sbin:$PATH

    if [ ! -d ~/.dotfiles ]; then
      git clone ${config.dotfiles.repo} ~/.dotfiles
      touch ~/.dotfiles/.nixos-managed
    fi

    pushd ~/.dotfiles
      if [ -e .nixos-managed ]; then
        git pull
      fi
      just dotbot
      just nix-index-fetch
    popd
  '';

  home.packages = [
    # my terms
    (pkgs.callPackage ./packages/terminfo {})

    pkgs.bat
    pkgs.bc
    pkgs.btop
    pkgs.calc
    pkgs.colordiff
    pkgs.comma
    pkgs.direnv
    pkgs.doggo
    pkgs.du-dust
    pkgs.fd
    pkgs.fzf
    pkgs.gitFull
    pkgs.gh
    pkgs.htop
    pkgs.jq
    pkgs.just
    pkgs.lazygit
    pkgs.lsd
    pkgs.mtr
    pkgs.pwgen
    pkgs.ripgrep
    pkgs.tio
    pkgs.tmux
    pkgs.tree
    pkgs.wget

    # global editor packages
    pkgs.nil
    pkgs.shellcheck
    pkgs.shfmt
  ];

  programs = {
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    starship.enable = true;
    zoxide = {
      enable = true;
      options = ["--cmd" "j"];
    };
  };

  xdg.enable = true;
}
