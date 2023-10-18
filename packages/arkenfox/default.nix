{
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater,
  writeScript,
}:
stdenvNoCC.mkDerivation rec {
  pname = "arkenfox";
  version = "118.0";

  src = fetchFromGitHub {
    owner = "arkenfox";
    repo = "user.js";
    rev = "refs/tags/${version}";
    hash = "sha256-/wW55BnbryBleWOvIGPA+QgeL28TN8lSuTwiFXTp9ss=";
  };

  dontPatch = true;
  dontBuild = true;
  dontConfigure = true;
  dontFixup = true;

  installPhase = let
    script = writeScript "arkenfox-patch" ''
      set -e
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
        cp ${src}/prefsCleaner.sh .
        cp ${src}/updater.sh .
        cp ${src}/user.js .
        chmod +w ./prefsCleaner.sh ./updater.sh ./user.js
        ln -sf ~/.dotfiles/apps/firefox/user-overrides.js .
        ./updater.sh -s
        bash ./prefsCleaner.sh -s
      done
    '';
  in ''
    mkdir -p $out/bin
    cp ${script} $out/bin/arkenfox-patch
  '';

  passthru.updateScript = gitUpdater {};

  meta.mainProgram = "arkenfox-patch";
}
