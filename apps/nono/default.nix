{
  dotlib,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [
    (pkgs.nono.overrideAttrs (old: {
      buildInputs =
        lib.throwIfNot (lib.versionOlder old.version "0.81.0") "remove nono buildInputs override"
          ((old.buildInputs or [ ]) ++ [ pkgs.aws-lc ]);
    }))
  ];

  xdg.configFile."nono/profiles".source = dotlib.source "apps/nono/profiles";
}
