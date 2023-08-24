{
  lib,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.fishPlugins.done
    pkgs.fishPlugins.foreign-env
    pkgs.fishPlugins.fzf-fish
  ];

  programs.fish = {
    enable = true;
    plugins = [];

    shellInit =
      (builtins.readFile ./init.fish)
      + (lib.optionalString pkgs.stdenv.isDarwin (builtins.readFile ./init-darwin.fish));

    loginShellInit = lib.optionalString pkgs.stdenv.isDarwin (builtins.readFile ./login-darwin.fish);

    interactiveShellInit =
      (builtins.readFile ./interactive.fish)
      + (lib.optionalString pkgs.stdenv.isDarwin (builtins.readFile ./interactive-darwin.fish));

    shellAbbrs = {
      da = "direnv allow";
      db = "direnv block";
      dc = "docker-compose";
      dclf = "docker-compose logs --tail=100 -f";
      dps = ''docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Command}}\t{{.Image}}"'';
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
      gt = "git tag --list -n1";
      ivl = "sudo iptables -vnL --line-numbers";
      jc = "sudo journalctl";
      jcu = "journalctl --user";
      sy = "sudo systemctl";
      syu = "systemctl --user";
    };

    shellAliases = {
      cat = "bat";
      cnf = "command-not-found";
      l = "ll -a";
      nix = "nix --print-build-logs";
      dog = "doggo";
      tree = "lsd --tree";
    };

    functions = {
      esl = "exec fish -l";
      uas = "set -x SSH_AUTH_SOCK $(tmux show-environment | sed -n 's/^SSH_AUTH_SOCK=//p')";
    };
  };
}
