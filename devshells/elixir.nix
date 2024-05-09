{
  lib,
  mkShell,
  stdenv,

  beam,
  inotify-tools,
  lexical,
  erlangR26,
}:
let
  beamPackages = beam.packagesWith erlangR26;
  elixir = beamPackages.elixir_1_16;
  lexical-ls = lexical.override { inherit elixir; };
  elixir-ls = beamPackages.elixir-ls;
in
mkShell {
  packages = [
    elixir
    lexical-ls
    elixir-ls
  ] ++ (lib.optionals stdenv.isLinux [ inotify-tools ]);

  shellHook = ''
    export ERL_AFLAGS="-kernel shell_history enabled -kernel shell_history_file_bytes 1024000"
  '';
}
