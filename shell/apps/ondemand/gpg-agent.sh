if [[ -d ~/.gnupg/private-keys-v1.d && $(ls -1 ~/.gnupg/private-keys-v1.d/ | wc -l) -gt 0 ]]
then
  pgrep gpg-agent &>/dev/null || eval $(gpg-agent --daemon)
fi
