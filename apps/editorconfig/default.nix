{ ... }:
{
  files.".editorconfig".text = ''
    root=true

    [*]
    end_of_line=lf
    indent_size=2
    indent_style=space

    [*.fish]
    indent_size=4

    [*.jl]
    indent_size=4

    [*.nu]
    indent_size=2

    [*.org]
    indent_size=8

    [*.py]
    indent_size=4

    [*.rs]
    indent_size=4

    [*.{nim,nims}]
    indent_size=2

    [Makefile]
    indent_style=tab

    [justfile]
    indent_size=4
  '';
}
