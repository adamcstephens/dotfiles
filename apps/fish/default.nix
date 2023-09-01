{
  config,
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

    shellAbbrs = config.home.shellAliases;

    functions = {
      esl = "exec fish -l";
      uas = "set -x SSH_AUTH_SOCK $(tmux show-environment | sed -n 's/^SSH_AUTH_SOCK=//p')";
    };
  };
}
