{
  config,
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
    ../apps/zellij
    ../apps/neovim
    ../apps/nix
    ../apps/ripgrep
    ../apps/shellcheck
    ../apps/sower
    ../apps/ssh
    ../apps/starship
    ../apps/tmux
    ../apps/wayland
    ../apps/xorg
    ../apps/yamlfmt
    ../apps/zsh
  ];

  dotfiles = {
    helix.enable = true;
  };

  home.stateVersion = "22.05";

  home.activation.dotfiles-migrate = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    ${lib.getExe pkgs.just} --justfile ${../justfile} migrate
  '';

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
    ll = "eza -lg";
    nix = "nix --print-build-logs";
    sy = "sudo systemctl";
    syu = "systemctl --user";
    tree = "eza --tree";
  };

  home.activation.directories = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    for dir in git projects tmp; do
      if [ ! -d $HOME/$dir ]; then
        mkdir -vp $HOME/$dir
      fi
    done
  '';

  home.activation.dotfiles-pull = lib.mkIf (!config.dotfiles.nixosManaged) (
    lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
      if [ ! -h ${config.home.homeDirectory}/.dotfiles ]; then
        pushd ${config.home.homeDirectory}/.dotfiles || exit 1
        # git pull, but don't error on failure
        ${lib.getExe pkgs.git} pull || true
      fi
    ''
  );

  home.file.".terminfo".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.profileDirectory}/share/terminfo";

  home.packages =
    let
      python = pkgs.python312;
    in
    [
      (python.withPackages (
        ps: with ps; [
          python-lsp-server
          pylsp-mypy
        ]
      ))

      pkgs.difftastic
      pkgs.direnv
      pkgs.doggo
      pkgs.du-dust
      pkgs.file
      pkgs.fx
      pkgs.gdu
      pkgs.jq
      pkgs.just
      pkgs.kalker
      pkgs.kitty.terminfo
      pkgs.ncdu
      pkgs.tio
      pkgs.viddy
      pkgs.wget
      pkgs.zf
    ];

  home.sessionVariables = {
    EDITOR = "${config.home.homeDirectory}/.dotfiles/bin/editor";
    PAGER = "${config.home.homeDirectory}/.dotfiles/bin/pager";
  };

  programs = {
    eza.enable = true;
    fzf.enable = true;
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    home-manager.enable = true;
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
