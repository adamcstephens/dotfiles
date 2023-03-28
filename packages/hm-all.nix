{
  bash,
  lib,
  homeConfigurations,
  writeScriptBin,
}:
writeScriptBin "hm-all" ''
  #!${lib.getExe bash}
  set -x

  : "''${RESULTNAME:=home}"

  targets=$(for profile in ${builtins.concatStringsSep " " (map (x: "'${x}'") homeConfigurations)}; do echo -n "$HOME/.dotfiles#homeConfigurations.$profile.activationPackage "; done)

  nom build --out-link ./results/$RESULTNAME --print-build-logs $targets
''
