{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./module.nix

    ./colors.nix

    ../apps/bash
    ../apps/bat
    ../apps/btop
    ../apps/editorconfig
    ../apps/emacs
    ../apps/fd
    ../apps/fish
    ../apps/git
    ../apps/helix
    ../apps/lsd
    ../apps/nushell
    ../apps/age
    ../apps/ripgrep
    ../apps/shellcheck
    ../apps/ssh
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

  nix.registry.nixpkgs.flake = lib.mkDefault inputs.nixpkgs;

  home.activation.directories = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    for dir in git projects tmp; do
      if [ ! -d $HOME/$dir ]; then
        mkdir -vp $HOME/$dir
      fi
    done
  '';

  home.activation.nix-index-fetch = lib.hm.dag.entryAfter ["writeBoundary"] ''
    pushd ~/.dotfiles
      PATH=${lib.makeBinPath [pkgs.bash pkgs.coreutils pkgs.gettext pkgs.wget]} ${lib.getExe pkgs.just} nix-index-fetch
    popd
  '';

  home.packages = [
    # my terms
    (pkgs.callPackage ../packages/terminfo {})

    pkgs.age-plugin-yubikey
    pkgs.bc
    pkgs.calc
    pkgs.comma
    pkgs.difftastic
    pkgs.direnv
    pkgs.doggo
    pkgs.du-dust
    pkgs.gh
    pkgs.htop
    pkgs.jless
    pkgs.jq
    pkgs.just
    pkgs.kitty.shell_integration
    pkgs.kitty.terminfo
    pkgs.lazygit
    pkgs.lsd
    pkgs.mtr
    pkgs.nix-output-monitor
    pkgs.pwgen
    pkgs.tio
    inputs.sandbox.packages.${pkgs.system}.trippy
    pkgs.wget

    # global editor packages
    pkgs.alejandra
    inputs.nil.packages.${pkgs.system}.nil
    (pkgs.nixfmt.overrideAttrs (old: {
      version = "0.6.0-${builtins.substring 0 7 inputs.nixfmt-rfc.rev}";

      src = inputs.nixfmt-rfc;
    }))
    pkgs.shfmt

    pkgs.babashka-unwrapped
  ];

  home.sessionVariables = {
    EDITOR = "${config.home.homeDirectory}/.dotfiles/bin/editor";
    PAGER = "${config.home.homeDirectory}/.dotfiles/bin/pager";
  };

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
