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

    shellAbbrs = lib.filterAttrs (k: _: !(builtins.elem k ["cat" "nix"])) config.home.shellAliases;
    shellAliases = {
      cat = "bat";
      nix = "nix --print-build-logs";
    };

    functions = {
      esl = "exec fish -l";
      uas = "set -x SSH_AUTH_SOCK $(tmux show-environment | sed -n 's/^SSH_AUTH_SOCK=//p')";
    };
  };

  xdg.configFile."fish/completions/mix.fish".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/halostatue/fish-elixir/b8947ae71eb551ce5cd0d31c7084fd684a9e5289/completions/mix.fish";
    hash = "sha256-kzbnU91ZLez0/pDgh1e14NyvtR6ST9ZXFSjAS6F6R/4=";
  };
}
