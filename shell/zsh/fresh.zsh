# follow fresh recommended  https://github.com/freshshell/fresh/wiki/Loading-Zsh-Completions
if [ -d ~/.fresh/build/completion ]
then
  fpath=(~/.fresh/build/completion $fpath)
fi
