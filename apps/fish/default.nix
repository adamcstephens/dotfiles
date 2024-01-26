{
  config,
  inputs,
  lib,
  npins,
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
        if test -n "$KITTY_WINDOW_ID"
            set --global KITTY_SHELL_INTEGRATION enabled
            source "${pkgs.kitty.shell_integration}/fish/vendor_conf.d/kitty-shell-integration.fish"
            set --prepend fish_complete_path "${pkgs.kitty.shell_integration}/fish/vendor_completions.d"
            source ${config.xdg.configHome}/fish/functions/autodark.fish
            source ${config.xdg.configHome}/fish/functions/uas.fish
        end
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
      autodark = {
        body = ''
          if test -f ~/.dotfiles/.dark-mode.state
              set dark_state (cat ~/.dotfiles/.dark-mode.state)
          else
              set dark_state true
          end

          if test -n "$auto_dark_mode" && test $auto_dark_mode = $dark_state
              return 0
          end

          if test $dark_state = true
              source ~/.config/fish/theme-dark.fish
          else
              source ~/.config/fish/theme-light.fish
          end

          set -g auto_dark_mode $dark_state
        '';
        onEvent = "fish_prompt";
      };
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

  xdg.configFile."fish/theme-dark.fish".source =
    npins."modus-themes.nvim" + "/extras/fish/modus_vivendi.fish";
  xdg.configFile."fish/theme-light.fish".source =
    npins."modus-themes.nvim" + "/extras/fish/modus_operandi.fish";
}
