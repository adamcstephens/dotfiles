{
  config,
  lib,
  pkgs,
  ...
}:
{

  nix = {
    package = lib.mkForce pkgs.nix;

    settings = {
      experimental-features =
        [
          "fetch-closure"
          "flakes"
          "nix-command"
        ]
        ++ lib.optionals (
          config.nix.package.pname == "nix" && lib.versionAtLeast config.nix.package.version "2.24"
        ) [ "pipe-operators" ]
        ++ lib.optionals (
          config.nix.package.pname == "lix" && lib.versionAtLeast config.nix.package.version "2.91"
        ) [ "pipe-operator" ];
      builders-use-substitutes = true;
      accept-flake-config = false;
    };
  };

}
