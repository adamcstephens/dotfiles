{
  bash,
  home-profile-selector,
  just,
  lib,
  nh,
  nix,
  nix-output-monitor,
  writeScriptBin,
}: let
  nixCmd = ''${nix}/bin/nix --extra-experimental-features "nix-command flakes"'';
in
  writeScriptBin "hm" ''
    #!${lib.getExe bash}
    set -e

    unset DISPLAY

    : "''${HMPROFILE:=$(${home-profile-selector}/bin/home-profile-selector)}"

    if [ -n "$1" ]; then
     ACTION=$1
    fi

    : "''${ACTION:=build}"
    TARGET=".#homeConfigurations.$HMPROFILE.activationPackage"

    case "$ACTION" in
      build)
        case "$TERM" in
          xterm*)
            ${lib.getExe nix-output-monitor} build --no-link $TARGET --print-build-logs || exit 1
            ;;
          *)
            ${nixCmd} build --no-link $TARGET --print-build-logs || exit 1
            ;;
        esac
      ;;
      switch)
        ${lib.getExe nh} home switch --configuration $HMPROFILE ~/.dotfiles
      ;;
      *)
        echo "⚠️ Invalid action $ACTION, ibailout."
        exit 1
    esac

    echo "🦾 Running migrations"
    ${lib.getExe just} --justfile ${../justfile} migrate

    echo "✅ Success!"
  ''
