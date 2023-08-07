#!/usr/bin/env sh
# shellcheck disable=SC2002

if [ ! -h "$HOME/.config/mimeapps.list" ]; then
  if [ -w "$HOME/.dotfiles/apps/mimeapps" ]; then # dump the current file so we know what changed
    newmime=$(cat "$HOME/.config/mimeapps.list" | rg -v '(Default Applications|(Added|Removed) Associations)' | rg -v '^$' | sed -e 's/^/"/' -e 's/=/" = ["/' -e 's/$/"];/' | sort -u)
    printf "{\n%s\n}" "$newmime" >"$HOME/.dotfiles/apps/mimeapps/default-applications.nix"
    alejandra --quiet "$HOME/.dotfiles/apps/mimeapps/default-applications.nix"
  fi
  rm -fv "$HOME/.config/mimeapps.list"
fi
