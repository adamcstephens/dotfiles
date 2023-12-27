{ pkgs }:
pkgs.mkShellNoCC {
  packages = [
    pkgs.delve
    pkgs.go
    pkgs.golangci-lint
    pkgs.gopls
    pkgs.go-tools
    pkgs.gotools

    pkgs.gptfdisk
    pkgs.qemu-utils
    pkgs.e2fsprogs
    pkgs.btrfs-progs
  ];
}
