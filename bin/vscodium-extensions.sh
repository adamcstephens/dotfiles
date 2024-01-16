#!/usr/bin/env sh

for codium in codium; do
  EXTENSIONS_FILE="$HOME/.dotfiles/apps/vscodium/$codium-extensions.txt"
  UNINSTALL_FILE="$HOME/.dotfiles/apps/vscodium/$codium-extensions-uninstall.txt"

  if command -v $codium >/dev/null 2>&1; then
    case "$(which $codium)" in
    *bin/remote-cli/*)
      exit 0
      ;;
    *)
      case $1 in
      install)
        TMPFILE="$(mktemp)"
        sed -e "/$2/Id" "$UNINSTALL_FILE" | sort -u >"$TMPFILE"
        mv "$TMPFILE" "$UNINSTALL_FILE"
        $codium --install-extension "$2"
        ;;
      remove)
        sed -i "/$2/Id" "$EXTENSIONS_FILE"
        $codium --uninstall-extension "$2"
        rc=$?
        TMPFILE="$(mktemp)"
        echo "$2" >>"$UNINSTALL_FILE"
        sort -u "$UNINSTALL_FILE" >"$TMPFILE"
        mv "$TMPFILE" "$UNINSTALL_FILE"
        exit $rc
        ;;
      esac

      installed="$($codium --list-extensions 2>/dev/null)"
      repo="$(cat "$EXTENSIONS_FILE")"
      uninstall="$(cat "$UNINSTALL_FILE")"

      for u in $uninstall; do
        ext=$(echo "$u" | sed -r 's/[[:space:]]+//g')
        if echo "$installed" | grep "$ext" >/dev/null; then
          $codium --uninstall-extension "$ext"
        fi
      done

      for e in $repo; do
        ext=$(echo "$e" | sed -r 's/[[:space:]]+//g')
        if ! (echo "$installed" | grep "$ext" >/dev/null); then
          $codium --install-extension "$ext"
        fi
      done

      $codium --list-extensions >"$EXTENSIONS_FILE" 2>/dev/null
      ;;
    esac
  fi
done
