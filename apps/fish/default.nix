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
    shellAliases = {
      cat = "bat";
      nix = "nix --print-build-logs";
      dog = "doggo";
    };

    # interactiveShellInit = ''
    #   sh ${nix-colors-contrib.shellThemeFromScheme {scheme = config.colorScheme;}}
    # '';
  };
}
