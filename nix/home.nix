{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../apps/fish
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
    pkgs.bat
    pkgs.bc
    pkgs.btop
    pkgs.calc
    pkgs.colordiff
    pkgs.direnv
    pkgs.doggo
    pkgs.du-dust
    pkgs.fd
    pkgs.fx
    pkgs.fzf
    pkgs.gitFull
    pkgs.gh
    pkgs.go-task
    pkgs.helix
    pkgs.htop
    pkgs.jq
    pkgs.just
    pkgs.lazygit
    pkgs.lsd
    pkgs.mtr
    pkgs.python3Minimal
    pkgs.python3Packages.black
    pkgs.python3Packages.ipython
    pkgs.python3Packages.rich
    pkgs.pwgen
    pkgs.ripgrep
    pkgs.shellcheck
    pkgs.shfmt
    pkgs.tio
    pkgs.tmux
    pkgs.tree
    pkgs.wget
    pkgs.zellij
  ];

  programs = {
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    lsd.enable = true;
    starship.enable = true;
    zoxide = {
      enable = true;
      options = ["--cmd" "j"];
    };
  };

  xdg.enable = true;
}
