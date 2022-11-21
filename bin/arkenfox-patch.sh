#!/usr/bin/env sh

if [ "$(uname)" = "Darwin" ]; then
  PROFILES_DIR=$HOME/Library/Application\ Support/Firefox/Profiles/
fi

if pgrep -i firefox; then
  echo "!! Quit all Firefox processes first !!"
  exit 1
fi

for FIREFOX_PROFILE in "$PROFILES_DIR"*; do
  echo "Arkenfoxing: $FIREFOX_PROFILE"
  cd "$FIREFOX_PROFILE" || exit 1
  cp ~/.dotfiles/apps/firefox/arkenfox/prefsCleaner.sh .
  cp ~/.dotfiles/apps/firefox/arkenfox/updater.sh .
  cp ~/.dotfiles/apps/firefox/arkenfox/user.js .
  ln -sf ~/.dotfiles/apps/firefox/user-overrides.js .
  ./updater.sh -s
  bash ./prefsCleaner.sh -s
done
