{ ... }:
{
  home.file.".bashrc".source = ./bashrc;
  home.file.".bash_profile".text = ''
    [[ -f ~/.bashrc ]] && . ~/.bashrc
  '';
}
