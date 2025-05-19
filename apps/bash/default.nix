{ config, ... }:
{
  programs.bash = {
    enable = true;
    initExtra = ''
      [[ -e "$HOME/.dotfiles/apps/shell_generic.sh" ]] && source "$HOME/.dotfiles/apps/shell_generic.sh"
    '';

    shellAliases = config.home.shellAliases;
  };
}
