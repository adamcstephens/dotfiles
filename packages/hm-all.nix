{
  bash,
  lib,
  homeConfigurations,
  writeScriptBin,
}:
writeScriptBin "hm-all" ''
  #!${lib.getExe bash}
  set -x

  targets=$(for profile in ${builtins.concatStringsSep " " (map (x: "'${x}'") homeConfigurations)}; do echo -n "$HOME/.dotfiles#homeConfigurations.$profile.activationPackage "; done)

  nom build --no-link --print-build-logs $targets
''
