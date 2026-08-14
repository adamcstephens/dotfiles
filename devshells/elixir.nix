{
  lib,
  mkShell,
  stdenv,

  beamMinimal28Packages,
  inotify-tools,
}:
let
  beamPackages = beamMinimal28Packages.extend (
    _: prev: {
      elixir = prev.elixir_1_19;
    }
  );
in
mkShell {
  packages = [
    beamPackages.erlang
    beamPackages.elixir
    beamPackages.elixir-ls
    beamPackages.hex
    beamPackages.rebar3
  ]
  ++ (lib.optionals stdenv.hostPlatform.isLinux [ inotify-tools ]);

  shellHook = ''
    export ERL_AFLAGS="-kernel shell_history enabled -kernel shell_history_file_bytes 1024000"
  '';
}
