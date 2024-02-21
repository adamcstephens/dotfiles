{
  mkShell,

  delve,
  gnumake,
  go,
  go-tools,
  golangci-lint,
  gopls,
  gotools,
  pcsclite,
  pkg-config,
}:
mkShell {
  packages = [
    delve
    go
    golangci-lint
    gopls
    go-tools
    gotools
    gnumake

    pkg-config
    pcsclite
  ];

  shellHook = ''
    export CGO_ENABLED=1
  '';
}
