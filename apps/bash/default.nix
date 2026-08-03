{ ... }:
{
  files.".bashrc".source = ./bashrc;
  files.".bash_profile".text = ''
    [[ -f ~/.bashrc ]] && . ~/.bashrc
  '';
}
