{
  lib,
  mkShell,
  stdenv,

  dexter,
  beamMinimal29Packages,
  inotify-tools,
  nodejs,
}:
let
  beamPackages = beamMinimal29Packages.overrideScope (
    _: prev: {
      elixir = prev.elixir_1_20;
    }
  );
in
mkShell {
  packages = [
    beamPackages.erlang
    beamPackages.elixir
    beamPackages.expert
    beamPackages.hex
    beamPackages.rebar3
    dexter
    nodejs
  ]
  ++ (lib.optionals stdenv.hostPlatform.isLinux [ inotify-tools ]);

  shellHook = ''
    export ERL_AFLAGS="-kernel shell_history enabled -kernel shell_history_file_bytes 1024000"
  '';
}
