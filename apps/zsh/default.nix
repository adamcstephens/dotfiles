{ config, ... }:
{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    history = {
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
      size = 100000;
    };

    initExtra = ''
      # shellcheck disable=SC1090
      [[ -e "$HOME/.dotfiles/apps/shell_generic.sh" ]] && source "$HOME/.dotfiles/apps/shell_generic.sh"

      # brew
      if type brew &>/dev/null; then
        FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
      fi

      [[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh 2>/dev/null)"

      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
    '';

    shellAliases = config.home.shellAliases;
  };
}
