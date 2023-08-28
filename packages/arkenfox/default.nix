{
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  writeScript,
}:
stdenvNoCC.mkDerivation rec {
  pname = "arkenfox";
  version = "115.1";

  src = fetchFromGitHub {
    owner = "arkenfox";
    repo = "user.js";
    rev = "refs/tags/${version}";
    hash = "sha256-M523JiwiZR0mwjyjNaojSERFt77Dp75cg0Ifd6wTOdU=";
  };

  dontPatch = true;
  dontBuild = true;
  dontConfigure = true;
  dontFixup = true;

  buildInputs = [makeWrapper];

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
    makeWrapper ${script} $out/bin/arkenfox-patch
  '';

  meta.mainProgram = "arkenfox-patch";
}
