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

  nix = {
    package = lib.mkForce pkgs.nix;
    settings = {
      experimental-features = "nix-command flakes";
      builders-use-substitutes = true;
    };
  };

  home.activation.dotfiles-bootstrap = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -d ~/.dotfiles ]; then
      ${lib.getExe pkgs.git} clone ${config.dotfiles.repo} ~/.dotfiles
      touch ~/.dotfiles/.nixos-managed
    fi

    pushd ~/.dotfiles
      if [ -e .nixos-managed ]; then
        ${lib.getExe pkgs.git} pull
      fi
    popd
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
          ${lib.getExe pkgs.git} pull
        fi
        ${lib.getExe pkgs.just} migrate
      popd
    fi
  '';

  home.sessionVariables = {
    EDITOR = "${config.home.homeDirectory}/.dotfiles/bin/editor";
    PAGER = "${config.home.homeDirectory}/.dotfiles/bin/pager";
  };

  home.activation.nix-index-fetch = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH=${lib.makeBinPath [pkgs.bash pkgs.coreutils pkgs.gettext pkgs.just pkgs.wget]}

    pushd ~/.dotfiles
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
