{
  self',
  pkgs,
  homeConfigurations,
  ...
}: let
  cachixRepo = "adamcstephens-dotfiles";
  nixCmd = ''nix --extra-experimental-features "nix-command flakes"'';
in {
  home-profile-selector = pkgs.writeScriptBin "home-profile-selector" ''
    #!${pkgs.python3Minimal}/bin/python3

    from socket import gethostname

    hm_profiles = [${builtins.concatStringsSep "," (map (x: "'${x}'") (builtins.attrNames homeConfigurations))}]
    hostname = gethostname()

    if hostname in hm_profiles:
        print(hostname)
    else:
        print("${pkgs.stdenv.hostPlatform.system}")
  '';

  hm-build = pkgs.writeScriptBin "hm-build" ''
    HMPROFILE="$(${self'.packages.home-profile-selector}/bin/home-profile-selector)"

    echo "building new profile for $HMPROFILE"
    ${nixCmd} build --no-link .#homeConfigurations.$HMPROFILE.activationPackage || exit 1
  '';

  hm-push = pkgs.writeScriptBin "hm-push" ''
    HMPROFILE="$(${self'.packages.home-profile-selector}/bin/home-profile-selector)"

    echo "cachix upload for $HMPROFILE"
    ${nixCmd} build --no-link .#homeConfigurations.$HMPROFILE.activationPackage --json | jq -r '.[].outputs | to_entries[].value' | cachix push ${cachixRepo}
  '';

  hm-switch = pkgs.writeScriptBin "hm-update" ''
    HMPROFILE="$(${self'.packages.home-profile-selector}/bin/home-profile-selector)"

    ${self'.packages.hm-build}/bin/hm-build

    old_profile=$(${nixCmd} profile list | grep home-manager-path | head -n1 | awk '{print $4}')
    if [ -n "$old_profile" ]; then
      echo "removing old profile: $old_profile"
      ${nixCmd} profile remove $old_profile
    fi

    echo "activating new profile"
    if ! "$(${nixCmd} path-info .#homeConfigurations.$HMPROFILE.activationPackage)"/activate; then
      echo "restoring old profile $old_profile"
      ${nixCmd} profile install $old_profile
      exit 1
    fi

    ${self'.packages.hm-push}/bin/hm-push
  '';
}
