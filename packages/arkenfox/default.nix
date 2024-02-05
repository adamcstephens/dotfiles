{
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater,
  writeScript,
}:
stdenvNoCC.mkDerivation rec {
  pname = "arkenfox";
  version = "122.0";

  src = fetchFromGitHub {
    owner = "arkenfox";
    repo = "user.js";
    rev = "refs/tags/${version}";
    hash = "sha256-624Giuo1TfeXQGzcGK9ETW86esNFhFZ5a46DCjT6K5I=";
  };

  patches = [ ./shhh.patch ];

  dontBuild = true;
  dontConfigure = true;
  dontFixup = true;

  installPhase =
    let
      script = writeScript "arkenfox-patch" ''
        set -e
        SCRIPT_DIR=$( cd -- "$( dirname -- "''${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

        if [ "$(uname)" = "Darwin" ]; then
          PROFILES_DIR="$HOME/Library/Application Support/Firefox/Profiles/"
        elif [ "$(uname)" = "Linux" ]; then
          PROFILES_DIR="$HOME/.mozilla/firefox/"
        fi
        if pgrep -i firefox; then
          echo "!! Quit all Firefox processes first !!"
          exit 1
        fi
        for FIREFOX_PROFILE in "$PROFILES_DIR"*; do
          if [ ! -e "$FIREFOX_PROFILE/cookies.sqlite" ]; then
            continue
          fi
          echo ":: Arkenfoxing: $FIREFOX_PROFILE ::"
          cd "$FIREFOX_PROFILE" || exit 1
          cp $SCRIPT_DIR/../src/prefsCleaner.sh .
          cp $SCRIPT_DIR/../src/updater.sh .
          cp $SCRIPT_DIR/../src/user.js .
          chmod +w ./prefsCleaner.sh ./updater.sh ./user.js
          ln -sf ~/.dotfiles/apps/firefox/user-overrides.js .
          ./updater.sh -s -d
          bash ./prefsCleaner.sh -s
        done
      '';
    in
    ''
      mkdir -p $out/{bin,src}
      cp ${script} $out/bin/arkenfox-patch
      cp prefsCleaner.sh $out/src
      cp updater.sh $out/src
      cp user.js $out/src
    '';

  passthru.updateScript = gitUpdater { };

  meta.mainProgram = "arkenfox-patch";
}
