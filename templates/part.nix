{ ... }:
{
  flake.templates = {
    default = {
      path = ./default;
      description = ''
        Basic template based on flake-parts for a devshell and direnv
      '';
    };
    elixir = {
      path = ./elixir;
    };
    ocaml = {
      path = ./ocaml;
      description = ''
        OCaml project template
      '';
    };
  };
}
