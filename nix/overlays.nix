{
  emacs,
  nixpkgs,
  ...
}: rec {
  default = nixpkgs.lib.composeManyExtensions [
    river
    emacs.overlays.emacs
    emacs.overlays.package
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
    });
  };
}
