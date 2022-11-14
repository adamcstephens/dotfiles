{
  emacs,
  nixpkgs,
  ...
}: rec {
  default = nixpkgs.lib.composeManyExtensions [
    emacs.overlays.emacs
    emacs.overlays.package
    gtklock
    river
    fishPlugins
    terminfo
  ];

  gtklock = _: prev: {gtklock = prev.callPackage ./packages/gtklock.nix {};};
  terminfo = _: prev: {terminfo = prev.callPackage ./packages/terminfo {};};

  river = final: prev: {
    river = prev.river.overrideAttrs (_: {
      version = "0.1.4pre";
      src = final.fetchFromGitHub {
        owner = "riverwm";
        repo = "river";
        rev = "e35c147cd5b8fcd363b7ecc495292733b25d96f5";
        sha256 = "sha256-orKL3imxpQXrSLj12Z3Zn5UuAW7P/JeOfoWCkb98eCM=";
        fetchSubmodules = true;
      };

      installPhase = ''
        runHook preInstall
        zig build -Drelease-safe -Dcpu=baseline -Dxwayland -Dman-pages --prefix $out install
        mkdir -p $out/share/wayland-sessions
        cp contrib/river.desktop $out/share/wayland-sessions
        runHook postInstall
      '';

      passthru = {
        providedSessions = ["river"];
      };
    });
  };

  # disable tests since they broke on darwin...
  fishPlugins = _: prev: {
    fishPlugins = prev.fishPlugins.overrideScope' (_: fprev: {
      fzf-fish = fprev.fzf-fish.overrideAttrs (_: {
        doCheck = false;
      });
    });
  };
}
