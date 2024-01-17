{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.fishPlugins.done
    pkgs.fishPlugins.foreign-env
    pkgs.fishPlugins.fzf-fish
  ];

  programs.fish = {
    enable = true;
    package = inputs.sandbox.packages.${pkgs.system}.fish;
    plugins = [ ];

    shellInit =
      (builtins.readFile ./init.fish)
      + (lib.optionalString pkgs.stdenv.isDarwin (builtins.readFile ./init-darwin.fish));

    loginShellInit = lib.optionalString pkgs.stdenv.isDarwin (builtins.readFile ./login-darwin.fish);

    interactiveShellInit =
      (builtins.readFile ./interactive.fish)
      + (lib.optionalString pkgs.stdenv.isDarwin (builtins.readFile ./interactive-darwin.fish))
      + ''
        set --global KITTY_SHELL_INTEGRATION enabled
        source "${pkgs.kitty.shell_integration}/fish/vendor_conf.d/kitty-shell-integration.fish"
        set --prepend fish_complete_path "${pkgs.kitty.shell_integration}/fish/vendor_completions.d"
      '';

    shellAbbrs =
      lib.filterAttrs
        (
          k: _:
          !(builtins.elem k [
            "cat"
            "nix"
          ])
        )
        config.home.shellAliases;
    shellAliases = {
      cat = "bat";
      nix = "nix --print-build-logs";
    };

    functions = {
      esl = "exec fish -l";
      uas = {
        body = ''
          if [ -z "$TMUX" ]
            return 0
          end

          ${lib.getExe pkgs.tmux} showenv -s | string replace -rf '^((?:SSH|DISPLAY).*?)=(".*?"); export.*' 'set -gx $1 $2' | source
        '';
        onEvent = "fish_preexec";
      };
    };
  };

  xdg.configFile."fish/completions/mix.fish".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/halostatue/fish-elixir/b8947ae71eb551ce5cd0d31c7084fd684a9e5289/completions/mix.fish";
    hash = "sha256-kzbnU91ZLez0/pDgh1e14NyvtR6ST9ZXFSjAS6F6R/4=";
  };

  # remove > 3.6.1
  xdg.configFile."fish/functions/__fish_is_zfs_feature_enabled.fish".source = ./zfs-completion-fix.fish;
}
