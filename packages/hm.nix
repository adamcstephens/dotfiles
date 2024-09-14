{
  lib,

  bash,
  git,
  home-profile-selector,
  jq,
  just,
  nixVersions,
  nix-output-monitor,
  nvd,
  writeScriptBin,
}:
let
  nixArgs = ''--extra-experimental-features "nix-command flakes" --print-build-logs'';
in
writeScriptBin "hm" ''
  #!${lib.getExe bash}
  set -e

  export PATH="${
    lib.makeBinPath [
      bash
      git
      home-profile-selector
      jq
      just
      nixVersions.nix_2_24
      nix-output-monitor
      nvd
    ]
  }"

  unset DISPLAY

  : "''${HMPROFILE:=$(home-profile-selector)}"

  if [ -n "$1" ]; then
    ACTION=$1
  fi

  : "''${ACTION:=build}"
  TARGET=".#homeConfigurations.$HMPROFILE.activationPackage"

  echo "🚴⚒Building home/$HMPROFILE"
  case "$TERM" in
    xterm*)
      BUILDER=nom
      ;;
    *)
      BUILDER=nix
      ;;
  esac
  PREVIOUS="$HOME/.local/state/nix/profiles/home-manager"
  NEXT=$($BUILDER build --no-link $TARGET ${nixArgs} --print-out-paths)

  if [ -z "$NEXT" ]; then
    echo "⚠️ Build failure, ibailout."
  fi

  nvd diff $PREVIOUS $NEXT

  case "$ACTION" in
    build)
      true
      ;;
    switch|sw)
      old_profile=$(nix ${nixArgs} profile list --json | jq -r '.elements."home-manager-path".storePaths[0]')
      if [ -n "$old_profile" ]; then
        echo "❌ Removing old profile: $old_profile"
        nix ${nixArgs} profile remove $old_profile
      fi

      echo " Activating new profile"
      if ! $NEXT/activate; then
        echo "❗ Failed to activate new profile"
        echo " Rolling back to old profile"
        nix ${nixArgs} profile install $old_profile
      fi

      echo "🦾 Running migrations"
      just --justfile ${../justfile} migrate
    ;;
    *)
      echo "‼️ Invalid action $ACTION, ibailout."
      exit 1
  esac

  echo "✅ Success!"
''
