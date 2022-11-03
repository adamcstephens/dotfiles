{
  emacs,
  nixpkgs,
  ...
}: rec {
  default = nixpkgs.lib.composeManyExtensions [
    emacs.overlays.emacs
    emacs.overlays.package
    river
    fishPlugins
  ];

  river = final: prev: {
    river = prev.river.overrideAttrs (old: {
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

  fishPlugins = final: prev: {
    fishPlugins = prev.fishPlugins.overrideScope' (ffinal: fprev: {
      fzf-fish = fprev.fzf-fish.overrideAttrs (_: {
        doCheck = false;
      });
    });
  };
}
