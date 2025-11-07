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

    ../apps/bat
    ../apps/btop
    ../apps/delta
    ../apps/editorconfig
    ../apps/fd
    ../apps/fish
    ../apps/git
    ../apps/helix
    ../apps/jjui
    ../apps/jujutsu
    ../apps/neovim
    ../apps/nix
    ../apps/ripgrep
    ../apps/shellcheck
    ../apps/sower
    ../apps/ssh
    ../apps/starship
    ../apps/tmux
    ../apps/tmuxinator
    ../apps/wayland
    ../apps/zellij
    ../apps/zsh
  ];

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
    jjc = "jj commit";
    jjd = "jj diff";
    jjbm = "jj bookmark move --to @-";
    jjgf = "jj git fetch --all-remotes";
    jjgp = "jj git push";
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

  systemd.user = lib.mkIf (!config.dotfiles.nixosManaged) {
    services.dotfiles-repo-pull = {
      Unit = {
        PartOf = [ "default.target" ];
      };

      Service = {
        Type = "oneshot";
        ExecStart =
          pkgs.writeShellApplication {
            name = "hypridle-before-sleep";

            runtimeInputs = [
              pkgs.git
              pkgs.jujutsu
            ];

            text = ''
              export PATH=${../bin}:$PATH

              if [ -d .jj ]; then
                jj home -r
              else
                git pull
              fi
            '';
          }
          |> lib.getExe;

        WorkingDirectory = "${config.home.homeDirectory}/.dotfiles";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    timers.dotfiles-repo-pull = {
      Timer.OnCalendar = "hourly";
      Install.WantedBy = [ "timers.target" ];
    };
  };

  home.file.".terminfo".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.profileDirectory}/share/terminfo";

  home.packages = [
    pkgs.difftastic
    pkgs.direnv
    pkgs.doggo
    # remove 25.11
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.dust
    pkgs.file
    pkgs.fzf
    pkgs.gdu
    pkgs.gojq
    pkgs.jless
    pkgs.just
    pkgs.kitty.terminfo
    pkgs.ncdu
    pkgs.python313
    pkgs.tio
    pkgs.viddy
    pkgs.wget
  ]
  ++ lib.optionals pkgs.stdenv.isLinux [
    pkgs.ghostty.terminfo
  ];

  home.sessionVariables = {
    EDITOR = "${config.home.homeDirectory}/.dotfiles/bin/editor";
    PAGER = "${config.home.homeDirectory}/.dotfiles/bin/pager";
  };

  programs = {
    eza.enable = true;
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
