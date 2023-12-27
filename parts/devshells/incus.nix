{ pkgs }:
pkgs.mkShell {
  packages = [
    pkgs.delve
    pkgs.go
    pkgs.golangci-lint
    pkgs.gopls
    pkgs.go-tools
    pkgs.gotools
    pkgs.gnumake

    pkgs.pkg-config
    pkgs.pcsclite
  ];

  shellHook = ''
    export CGO_ENABLED=1
  '';
}
