#!/usr/bin/env nix-shell
#! nix-shell -i bash -p gojq

# need a few keys from this massive state file, or won't be logged in and requires onboarding
# shellcheck: disable=SC2016
gojq --arg p "$PWD" '{oauthAccount, userID, hasCompletedOnboarding, projects: (if .projects[$p] then {($p): .projects[$p]} else {} end)}' <~/.claude.json |
  "$EPI_BIN" exec "$EPI_INSTANCE" -- "cat > ~/.claude.json"
