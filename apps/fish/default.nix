{
  config,
  inputs,
  pkgs,
  ...
}: let
  nix-colors-contrib = inputs.nix-colors.lib-contrib {inherit pkgs;};
in {
  home.packages = [
    pkgs.fishPlugins.done
    pkgs.fishPlugins.foreign-env
    pkgs.fishPlugins.fzf-fish
  ];

  programs.fish = {
    enable = true;
    plugins = [];

    interactiveShellInit = ''
      set -U __done_notification_urgency_level_failure normal
    '';

    shellAliases = {
      cat = "bat";
      cnf = "command-not-found";
      l = "ll -a";
      nix = "nix --print-build-logs";
      dog = "doggo";
    };
  };
}
