if type brew 2&>/dev/null; then
  # shellcheck source=/dev/null
  source "$(brew --prefix)/etc/bash_completion.d/*"
else
  echo "run: brew install git bash-completion"
fi
