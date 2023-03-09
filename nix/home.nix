{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../apps/bash
    ../apps/bat
    ../apps/btop
    ../apps/editorconfig
    ../apps/fish
    ../apps/lsd
    ../apps/ripgrep
    ../apps/shellcheck
    ../apps/starship
    ../apps/zsh
  ];

  home.stateVersion = "22.05";

  programs.home-manager.enable = true;

  home.activation.a-link-nix = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    mkdir -vp $HOME/.config/nix/
    ln -sfv $HOME/.dotfiles/apps/nix/nix.conf $HOME/.config/nix/nix.conf
  '';

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

    pkgs.bc
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
    pkgs.nix-output-monitor
    pkgs.pwgen
    pkgs.tio
    pkgs.tmux
    pkgs.tree
    pkgs.wget

    # global editor packages
    pkgs.nil
    pkgs.shfmt
  ];

  programs = {
    fzf.enable = true;
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    zoxide = {
      enable = true;
      options = ["--cmd" "j"];
    };
  };

  xdg.enable = true;
}
