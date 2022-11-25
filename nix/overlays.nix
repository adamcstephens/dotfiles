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
    wlroots
    wob
  ];

  gtklock = _: prev: {gtklock = prev.callPackage ./packages/gtklock.nix {};};
  terminfo = _: prev: {terminfo = prev.callPackage ./packages/terminfo {};};

  river = final: prev: {
    river = prev.river.overrideAttrs (_: {
      version = "0.1.4pre1";
      src = final.fetchFromGitHub {
        owner = "riverwm";
        repo = "river";
        rev = "3141940efb7a241cc4998e7f8263533823f75ef3";
        hash = "sha256-aa2qAkYjn3v5I2DoSm5JYKBojrR27E56+phWhK+pB7M=";
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

  wlroots = _: prev: {
    wlroots = prev.wlroots_0_16;
  };

  wob = _: prev: {
    wob = prev.wob.overrideAttrs (pprev: {
      version = "0.14";
      src = prev.fetchFromGitHub {
        owner = "francma";
        repo = "wob";
        rev = "0.14";
        sha256 = "sha256-lZlzWXZwmuD8G/PUC94HhJsRBM17O+f8ffOD6s1mHXI=";
      };
      buildInputs = [prev.inih] ++ pprev.buildInputs;
    });
  };
}
