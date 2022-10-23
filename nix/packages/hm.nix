{
  pkgs,
  homeConfigurations,
  ...
}: let
  cachixRepo = "adamcstephens-dotfiles";
  nixCmd = ''${pkgs.nix}/bin/nix --extra-experimental-features "nix-command flakes"'';
in rec {
  home-profile-selector = pkgs.writeScriptBin "home-profile-selector" ''
    #!${pkgs.python3Minimal}/bin/python3

    from socket import gethostname

    hm_profiles = [${builtins.concatStringsSep "," (map (x: "'${x}'") homeConfigurations)}]
    hostname = gethostname()

    if hostname in hm_profiles:
        print(hostname)
    else:
        print("${pkgs.stdenv.hostPlatform.system}")
  '';
  hm-all = pkgs.writeScriptBin "hm-all" ''
    for profile in ${builtins.concatStringsSep " " (map (x: "'${x}'") homeConfigurations)}; do
      HMPROFILE=$profile ${hm}/bin/hm push
    done
  '';
  hm = pkgs.writeScriptBin "hm" ''
    set -e

    : "''${HMPROFILE:=$(${home-profile-selector}/bin/home-profile-selector)}"

    if [ -n "$1" ]; then
     ACTION=$1
    fi

    : "''${ACTION:=build}"

    TARGET=".#homeConfigurations.$HMPROFILE.activationPackage"

    echo " Running action $ACTION"

    echo "🚧 Building new profile for $HMPROFILE"
    ${nixCmd} build --no-link $TARGET --print-build-logs || exit 1

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

    if [ "$ACTION" = "push" ]; then
      echo " cachix upload for $HMPROFILE"
      ${nixCmd} build --no-link $TARGET --json | jq -r '.[].outputs | to_entries[].value' | ${pkgs.cachix}/bin/cachix push ${cachixRepo}
    fi

    echo "✅ Success!"
  '';
}
