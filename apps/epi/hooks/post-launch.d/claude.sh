#!/usr/bin/env nix-shell
#! nix-shell -i bash -p gojq

# need a few keys from this massive state file, or won't be logged in and requires onboarding
gojq '{oauthAccount,userID,hasCompletedOnboarding}' <~/.claude.json |
  "$EPI_BIN" exec "$EPI_INSTANCE" -- "cat > ~/.claude.json"

# there's also a second place the claude secret is stored.
"$EPI_BIN" cp ~/.claude/.credentials.json "$EPI_INSTANCE:.claude/"
