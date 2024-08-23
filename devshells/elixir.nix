{
  lib,
  mkShell,
  stdenv,

  beam_minimal,
  inotify-tools,
  next-ls,
}:
let
  beamPackages = beam_minimal.packages.erlang_27;
  elixir = beamPackages.elixir_1_17;
  elixir-ls = (beamPackages.elixir-ls.override { inherit elixir; });
in
mkShell {
  packages = [
    beamPackages.erlang
    elixir
    elixir-ls
    next-ls
  ] ++ (lib.optionals stdenv.isLinux [ inotify-tools ]);

  shellHook = ''
    export ERL_AFLAGS="-kernel shell_history enabled -kernel shell_history_file_bytes 1024000"
  '';
}
