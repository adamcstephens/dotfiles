#!/usr/bin/env bash

# arguments are: <event> <previous state> <new state>
# see man gammastep

# EVENT=$1
PREV=$2
NEW=$3

dark() {
  ~/.dotfiles/bin/dark-mode enable

}

light() {
  ~/.dotfiles/bin/dark-mode disable
}

case $1 in
  period-changed)
    if [[ $PREV == "daytime" && $NEW == "transition" ]]; then
      dark
    elif [[ $PREV == "night" && $NEW == "transition" ]]; then
      light
    elif [[ $NEW == "night" ]]; then
      dark
    elif [[ $NEW == "daytime" ]]; then
      light
    fi
    ;;
  *)
    :
esac

echo "$(date) Received: $*" &>> $HOME/.cache/gammastep.log
