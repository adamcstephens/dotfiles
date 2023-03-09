{...}: {
  programs.bash = {
    enable = true;
    initExtra = ''
      [[ -e "$HOME/.dotfiles/apps/shell_generic.sh" ]] && source "$HOME/.dotfiles/apps/shell_generic.sh"

      [[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path bash 2>/dev/null)"
    '';
  };
}
