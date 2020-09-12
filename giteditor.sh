#!/usr/bin/env bash

if [[ "$TERM_PROGRAM" == "vscode" ]]
then
  exec code --wait $@
else
  exec vim $@
fi
