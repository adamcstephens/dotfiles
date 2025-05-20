{ npins, ... }:
{
  programs.tmux = {
    enable = true;
    extraConfig =
      builtins.readFile "${npins.vim-moonfly-colors}/extras/moonfly.tmux" + builtins.readFile ./tmux.conf;
  };
}
