{ npins, pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    extraConfig =
      builtins.readFile "${npins."modus-themes.nvim"}/extras/tmux/modus_vivendi.tmux"
      + builtins.readFile ./tmux.conf;

    # plugins = [
    #   {
    #     plugin = pkgs.tmuxPlugins.tmux-fzf;
    #     extraConfig = "set -g @plugin 'sainnhe/tmux-fzf'";
    #   }
    # ];
  };
}
