{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./module.nix

    ../apps/bash
    ../apps/bat
    ../apps/btop
    ../apps/editorconfig
    ../apps/fd
    ../apps/fish
    ../apps/git
    ../apps/helix
    ../apps/neovim
    ../apps/nushell
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
    glo = ''git log --date=iso --format="%C(auto)%h %C(auto,blue)[%ar]%C(auto)%d %s" --max-count=15'';
    gp = "git push";
    grh = "git reset HEAD";
    grv = "git remote -v";
    gs = "git status";
    gss = "git status --short";
    gsw = "git switch";
    gswc = "git switch --create";
    gw = "git worktree";
    gt = "git tag --list -n1";
    ivl = "sudo iptables -vnL --line-numbers";
    jc = "sudo journalctl";
    jcu = "journalctl --user";
    l = "ll -a";
    ll = "eza -l";
    nix = "nix --print-build-logs";
    sy = "sudo systemctl";
    syu = "systemctl --user";
    tree = "eza --tree";
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

  home.activation.directories = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    for dir in git projects tmp; do
      if [ ! -d $HOME/$dir ]; then
        mkdir -vp $HOME/$dir
      fi
    done
  '';

  home.packages = [
    pkgs.calc
    pkgs.difftastic
    pkgs.direnv
    pkgs.doggo
    pkgs.du-dust
    pkgs.fx
    pkgs.gdu
    pkgs.gh
    pkgs.jq
    pkgs.just
    pkgs.kitty.terminfo
    pkgs.mtr
    pkgs.tio
    pkgs.wget
  ];

  home.sessionVariables = {
    EDITOR = "${config.home.homeDirectory}/.dotfiles/bin/editor";
    PAGER = "${config.home.homeDirectory}/.dotfiles/bin/pager";
  };

  programs = {
    eza = {
      enable = true;
    };

    fzf.enable = true;
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    zoxide = {
      enable = true;
      options = [
        "--cmd"
        "j"
      ];
    };
  };

  xdg.enable = true;
}
