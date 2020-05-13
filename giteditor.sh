#!/bin/bash

if [[ "$TERM_PROGRAM" == "vscode" ]]
then
  exec code --wait $@
elif command -v nvim
then
  exec nvim $@
else
  exec vim $@
fi