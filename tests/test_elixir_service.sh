#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
work=$(mktemp --directory /tmp/elixir-service.XXXXXXXX)
trap 'rm --recursive --force "$work"' EXIT

for phoenix in false true; do
  for postgres in false true; do
    project="$work/$phoenix-$postgres/feed-reader"
    nix run "$root#elixir-service" -- --defaults --data phoenix="$phoenix" --data postgres="$postgres" "$project"
    (
      cd "$project"
      nix build --no-link .#default .#checks.x86_64-linux.service
      nix develop --command bash -seu -- "$postgres" <<'CHECK'
        just mix-nix-lock
        nix-instantiate --parse deps.nix >/dev/null
        if [[ $1 == true ]]; then
          just pc up --detached
          trap "just pc down" EXIT
          test "$(just pc process list)" = postgres_db
        else
          test ! -e .services
        fi
        just check
CHECK
    )
  done
done
