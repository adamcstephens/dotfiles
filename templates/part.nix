{ ... }:
{
  flake.templates = {
    default = {
      path = ./default;
      description = "Basic template based on flake-parts for a devshell and direnv";
    };
    elixir = {
      path = ./elixir;
      description = "Elixir project template";
    };
    ocaml = {
      path = ./ocaml;
      description = "OCaml project template";
    };
    rust = {
      path = ./rust;
      description = "Rust project template";
    };
    rust-cli = {
      path = ./rust-cli;
      description = "Rust CLI app with Nix packaging and dynamic shell completions";
    };
  };
}
