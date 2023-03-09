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
    ../apps/git
    ../apps/lsd
    ../apps/ripgrep
    ../apps/shellcheck
    ../apps/starship
    ../apps/tmux
    ../apps/zsh
  ];

  home.stateVersion = "22.05";

  programs.home-manager.enable = true;

  home.activation.a-link-nix = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    mkdir -vp $HOME/.config/nix/

    if [ ! -h $HOME/.config/nix/nix.conf ]; then
      ln -sf $HOME/.dotfiles/apps/nix/nix.conf $HOME/.config/nix/nix.conf
    fi
  '';

  home.activation.directories = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    for dir in git projects tmp; do
      if [ ! -d $HOME/$dir ]; then
        mkdir -vp $HOME/$dir
      fi
    done
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

  home.sessionVariables = {
    EDITOR = "~/.dotfiles/bin/editor";
    PAGER = "~/.dotfiles/bin/pager";
  };

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
