#!/usr/bin/env bash

# arguments are: <event> <previous state> <new state>
# see man gammastep


dark() {
  gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark
}

light() {
  gsettings set org.gnome.desktop.interface gtk-theme Adwaita
}

case $1 in
  period-changed)
    if [[ $2 == "daytime" && $3 == "transition" ]]; then
      dark
    elif [[ $2 == "night" && $3 == "transition" ]]; then
      light
    elif [[ $2 == "none" && $3 == "night" ]]; then
      dark
    elif [[ $2 == "none" && $3 == "daytime" ]]; then
      light
    fi
    ;;
  *)
    :
esac
