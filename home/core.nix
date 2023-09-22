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
    ../apps/zellij
    ../apps/zsh
  ];

  home.stateVersion = "22.05";

  home.shellAliases = {
    cat = "bat";
    cnf = "command-not-found";
    da = "direnv allow";
    db = "direnv block";
    dc = "docker-compose";
    dclf = "docker-compose logs --tail=100 -f";
    dog = "doggo";
    dps = ''docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Command}}\t{{.Image}}"'';

    f = "fossil";
    fs = "fossil status";

    ga = "git add";
    gbv = "git branch --all --verbose --verbose";
    gc = "git commit";
    gd = "git diff";
    gl = "git pull";
    glo = "git log --decorate --pretty=oneline --abbrev-commit --max-count=15";
    gp = "git push";
    grh = "git reset HEAD";
    grv = "git remote -v";
    gs = "git status";
    gss = "git status --short";
    gsw = "git switch";
    gswc = "git switch --create";
    gt = "git tag --list -n1";
    ivl = "sudo iptables -vnL --line-numbers";
    jc = "sudo journalctl";
    jcu = "journalctl --user";
    l = "ll -a";
    nix = "nix --print-build-logs";
    sy = "sudo systemctl";
    syu = "systemctl --user";
    tree = "lsd --tree";
  };

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

  home.packages = [
    # my terms
    (pkgs.callPackage ../packages/terminfo {})

    pkgs.age-plugin-yubikey
    pkgs.bc
    pkgs.calc
    inputs.nix-index-database.packages.${pkgs.system}.comma-with-db
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
    carapace = {
      enable = true;
      enableFishIntegration = false; # ifd...
    };

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
