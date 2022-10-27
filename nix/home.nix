{
  pkgs,
  config,
  lib,
  ...
}: {
  # https://github.com/NixOS/nixpkgs/issues/196651
  manual.manpages.enable = false;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "1password"
      "plexamp"
      "slack"
      "vscode"
    ];

  home.stateVersion = "22.05";

  programs.home-manager.enable = true;

  home.activation.dotfiles-migrate = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    cd ~/.dotfiles
    ${pkgs.just}/bin/just migrate
  '';

  home.activation.dotfiles-bootstrap = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH=${config.home.path}/bin:${config.home.path}/sbin:$PATH

    if [ ! -d ~/.dotfiles ]; then
      git clone https://git.sr.ht/~adamcstephens/dotfiles ~/.dotfiles
      touch ~/.dotfiles/.nixos-managed
    fi

    pushd ~/.dotfiles
      if [ -e .nixos-managed ]; then
        git pull
      fi
      just dotbot
    popd
  '';

  home.packages = [
    pkgs.alejandra
    pkgs.bat
    pkgs.btop
    pkgs.calc
    pkgs.colordiff
    pkgs.direnv
    pkgs.dogdns
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
    pkgs.nil
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
  ];

  programs = {
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    fish.enable = true;
    lsd.enable = true;
    starship.enable = true;
    zoxide.enable = true;
  };
}
