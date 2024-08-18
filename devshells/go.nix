{
  mkShell,

  delve,
  gnumake,
  go_1_23,
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
    go_1_23
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
