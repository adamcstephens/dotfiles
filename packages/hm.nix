{
  bash,
  home-profile-selector,
  lib,
  nix,
  nix-output-monitor,
  writeScriptBin,
}: let
  nixCmd = ''${nix}/bin/nix --extra-experimental-features "nix-command flakes"'';
in
  writeScriptBin "hm" ''
    #!${lib.getExe bash}
    set -e

    : "''${HMPROFILE:=$(${home-profile-selector}/bin/home-profile-selector)}"

    if [ -n "$1" ]; then
     ACTION=$1
    fi

    : "''${ACTION:=build}"

    TARGET=".#homeConfigurations.$HMPROFILE.activationPackage"

    echo " Running action $ACTION"

    echo "🚧 Building new profile for $HMPROFILE"
    ${lib.getExe nix-output-monitor} build --no-link $TARGET --print-build-logs || exit 1

    if [ "$ACTION" = "show" ]; then
      ${nixCmd} show-derivation $TARGET
      exit 0
    fi

    if [ "$ACTION" = "switch" ]; then
      old_profile=$(${nixCmd} profile list | grep home-manager-path | head -n1 | awk '{print $4}')
      if [ -n "$old_profile" ]; then
        echo "❌ Removing old profile: $old_profile"
        ${nixCmd} profile remove $old_profile
      fi

      echo " Activating new profile"
      if ! "$(${nixCmd} path-info $TARGET)"/activate; then
        echo "❗ Failed to activate new profile"
        echo " Rolling back to old profile"
        ${nixCmd} profile install $old_profile
        exit 1
      fi
    fi

    echo "✅ Success!"
  ''
