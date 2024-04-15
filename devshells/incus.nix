{ pkgs }:
pkgs.mkShell {
  packages = [
    # go
    pkgs.delve
    pkgs.go
    pkgs.golangci-lint
    pkgs.gopls
    pkgs.go-tools
    pkgs.gotools

    # build deps
    pkgs.pkg-config
    pkgs.acl
    pkgs.cowsql.dev
    pkgs.gnumake
    pkgs.libcap
    pkgs.lxc
    pkgs.sqlite
    pkgs.udev.dev

    # dev deps
    (pkgs.aspellWithDicts (
      dicts: with dicts; [
        en
        en-computers
        en-science
      ]
    ))
    pkgs.debianutils
    pkgs.gettext
    pkgs.go-swagger
    (pkgs.python3.withPackages (ps: [ ps.flake8 ]))
    (pkgs.callPackage ./xgettext-go.nix { })
  ];

  # delve fix
  hardeningDisable = [ "fortify" ];

  shellHook = ''
    export CGO_ENABLED=1
  '';
}
