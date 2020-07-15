#!/usr/bin/env sh

if [ "$TERM_PROGRAM" == "vscode" ]
then
  exec code --wait $@
else
  exec vim $@
fi
