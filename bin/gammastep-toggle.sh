#!/usr/bin/env bash

# arguments are: <event> <previous state> <new state>
# see man gammastep

# EVENT=$1
PREV=$2
NEW=$3

dark() {
  gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark
  # kitty @ set-colors --reset

}

light() {
  gsettings set org.gnome.desktop.interface gtk-theme Adwaita
  # kitty @ set-colors --all --configured ~/.config/kitty/theme-light.conf
}

case $1 in
  period-changed)
    if [[ $PREV == "daytime" && $NEW == "transition" ]]; then
      dark
    elif [[ $PREV == "night" && $NEW == "transition" ]]; then
      light
    elif [[ $PREV == "none" && $NEW == "night" ]]; then
      dark
    elif [[ $PREV == "none" && $NEW == "daytime" ]]; then
      light
    fi
    ;;
  *)
    :
esac

echo "Received: $*" 1>&2
