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

    pushd ~/.dotfiles
      task dotbot
    popd
  '';

  home.packages = [
    pkgs.alejandra
    pkgs.btop
    pkgs.du-dust
    pkgs.fd
    pkgs.fzf
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
    pkgs.ripgrep
    pkgs.shellcheck
    pkgs.shfmt
    pkgs.starship
    pkgs.zoxide
  ];

  programs.emacs = {
    enable = true;
    # package = pkgs.emacsNativeComp;
  };

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ../doom.d;
  };
}
