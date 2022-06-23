#!/usr/bin/env sh

EXTENSIONS_FILE="$HOME/.dotfiles/vscode/extensions.txt"
UNINSTALL_FILE="$HOME/.dotfiles/vscode/extensions-uninstall.txt"

for code in code code-insiders; do
  if command -v $code >/dev/null 2>&1; then
    case "$(which code)" in
    *bin/remote-cli/*)
      exit 0
      ;;
    *)
      case $1 in
      install)
        sed -i "/$2/d" "$UNINSTALL_FILE"
        $code --install-extension "$2"
        ;;
      remove)
        sed -i "/$2/d" "$EXTENSIONS_FILE"
        $code --uninstall-extension "$2"
        echo "$2" >>"$UNINSTALL_FILE"
        exit $?
        ;;
      esac

      installed="$($code --list-extensions 2>/dev/null)"
      repo="$(cat "$EXTENSIONS_FILE")"
      uninstall="$(cat "$UNINSTALL_FILE")"

      for u in $uninstall; do
        if echo "$installed" | grep "$u" >/dev/null; then
          $code --uninstall-extension "$u"
        fi
      done

      for e in $repo; do
        if ! (echo "$installed" | grep "$e" >/dev/null); then
          $code --install-extension "$e"
        fi
      done

      $code --list-extensions >"$EXTENSIONS_FILE" 2>/dev/null
      ;;
    esac
  fi
done
