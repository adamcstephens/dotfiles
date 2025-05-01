{
  mkShell,
  pkgs,
}:
mkShell {
  packages = with pkgs; [
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
