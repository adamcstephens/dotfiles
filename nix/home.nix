{
  pkgs,
  config,
  lib,
  ...
}: {
  home.stateVersion = "22.05";

  programs.home-manager.enable = true;

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
      task dotbot
    popd
  '';

  home.packages = [
    pkgs.alejandra
    pkgs.bat
    pkgs.btop
    pkgs.calc
    pkgs.colordiff
    pkgs.direnv
    pkgs.du-dust
    pkgs.fd
    pkgs.fzf
    pkgs.git
    pkgs.gh
    pkgs.go-task
    pkgs.helix
    pkgs.htop
    pkgs.jq
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
    lsd.enable = true;
    starship = {
      enable = true;
      enableBashIntegration = false;
      enableFishIntegration = false;
      enableZshIntegration = false;
    };
    zoxide = {
      enable = true;
      enableBashIntegration = false;
      enableFishIntegration = false;
      enableZshIntegration = false;
    };
  };
}
