#!/usr/bin/env sh

# load config from nix, such as colors
~/.config/river/colors.sh
# ensure WAYLAND_DISPLAY gets to user systemd env
systemctl --user import-environment DISPLAY WAYLAND_DISPLAY
systemctl --user start wayland-session.target

#
## input
#
riverctl list-inputs | grep Magic_Trackpad | sort -u | while read -r trackpad; do
  riverctl input "$trackpad" natural-scroll enabled
  riverctl input "$trackpad" tap-button-map left-right-middle
done

riverctl set-repeat 60 300

touchpad="$(riverctl list-inputs | rg Touchpad | head -n 1)"

riverctl input $touchpad events disabled
riverctl input $touchpad natural-scroll enabled
riverctl input $touchpad tap-button-map left-right-middle
riverctl input $touchpad middle-emulation disabled

riverctl focus-follows-cursor always || riverctl focus-follows-cursor normal

#
## map
#
riverctl focus-follows-cursor always || riverctl focus-follows-cursor normal
riverctl map normal Super+Shift T spawn 'systemd-cat --identifier=ghostty ghostty'
riverctl map normal Super+Shift Return spawn 'systemd-cat --identifier=ghostty ghostty'
riverctl map normal Super+Shift+Control E spawn 'systemd-cat --identifier=gtk-launch gtk-launch emacsclient'
riverctl map normal Super D spawn 'systemd-cat --identifier=rofi rofi -show drun'
riverctl map normal Super+Shift D spawn 'systemd-cat --identifier=rofi rofi -show emoji'
riverctl map normal Super+Shift+Control D spawn 'systemd-cat --identifier=prj prj'

riverctl map normal None Print spawn 'systemd-cat --identifier=screenshot screenshot screen'
# bindsym print exec screenshot.sh window
# bindsym $mod+print exec screenshot.sh screen
# bindsym Alt+print exec screenshot.sh box

riverctl map normal Super+Shift Q close
riverctl map normal Super+Shift+Control X exit

# Mod+J and Mod+K to focus the next/previous view in the layout stack
riverctl map normal Super J focus-view next
riverctl map normal Super K focus-view previous
riverctl map normal Super S focus-view next
riverctl map normal Super W focus-view previous

# Mod+Shift+J and Mod+Shift+K to swap the focused view with the next/previous
# view in the layout stack
riverctl map normal Super+Shift J swap next
riverctl map normal Super+Shift K swap previous
riverctl map normal Super+Shift S swap next
riverctl map normal Super+Shift W swap previous

# Mod+Period and Mod+Comma to focus the next/previous output
riverctl map normal Super Period focus-output next
riverctl map normal Super Comma focus-output previous

# Mod+Shift+{Period,Comma} to send the focused view to the next/previous output
riverctl map normal Super+Shift Period send-to-output next
riverctl map normal Super+Shift Comma send-to-output previous

# Mod+Return to bump the focused view to the top of the layout stack
riverctl map normal Super A zoom
riverctl map normal Super Return zoom

# Mod+H and Mod+L to decrease/increase the main ratio of rivertile(1)
riverctl map normal Super+Shift H send-layout-cmd rivertile "main-ratio -0.05"
riverctl map normal Super+Shift L send-layout-cmd rivertile "main-ratio +0.05"

# Mod+Alt+{H,J,K,L} to move views
riverctl map normal Super+Alt H move left 100
riverctl map normal Super+Alt J move down 100
riverctl map normal Super+Alt K move up 100
riverctl map normal Super+Alt L move right 100

# Mod+Alt+Control+{H,J,K,L} to snap views to screen edges
riverctl map normal Super+Alt+Control H snap left
riverctl map normal Super+Alt+Control J snap down
riverctl map normal Super+Alt+Control K snap up
riverctl map normal Super+Alt+Control L snap right

# Mod+Alt+Shif+{H,J,K,L} to resize views
riverctl map normal Super+Alt+Shift H resize horizontal -100
riverctl map normal Super+Alt+Shift J resize vertical 100
riverctl map normal Super+Alt+Shift K resize vertical -100
riverctl map normal Super+Alt+Shift L resize horizontal 100

# Mod + Left Mouse Button to move views
# riverctl map-pointer normal Super BTN_LEFT move-view

# Mod + Right Mouse Button to resize views
# riverctl map-pointer normal Super BTN_RIGHT resize-view

focus_tag_map() {
  if command -v river-bnf; then
    riverctl map "$1" "$2" "$3" spawn "river-bnf $4"
  else
    riverctl map "$1" "$2" "$3" set-focused-tags "$4"
  fi
}

for i in $(seq 1 9); do
  tags=$((1 << (i - 1)))

  # Mod+[1-9] to focus tag [0-8]
  focus_tag_map normal Super "$i" $tags

  # Mod+Shift+[1-9] to tag focused view with tag [0-8]
  riverctl map normal Super+Shift "$i" set-view-tags $tags

  # Mod+Ctrl+[1-9] to toggle focus of tag [0-8]
  riverctl map normal Super+Control "$i" toggle-focused-tags $tags

  # Mod+Shift+Ctrl+[1-9] to toggle tag [0-8] of focused view
  riverctl map normal Super+Shift+Control "$i" toggle-view-tags $tags
done

# Mod+0 to focus all tags
# Mod+Shift+0 to tag focused view with all tags
all_tags=$(((1 << 32) - 1))
riverctl map normal Super 0 set-focused-tags $all_tags
riverctl map normal Super+Shift 0 set-view-tags $all_tags

riverctl map normal Super Grave focus-previous-tags

# Mod+Space to toggle float
riverctl map normal Super+Shift Space toggle-float

# Mod+F to toggle fullscreen
riverctl map normal Super+Shift F toggle-fullscreen
riverctl map normal Super+Control+Shift P spawn 'systemd-cat --identifier=wl-present wl-present mirror'

# Mod+{Up,Right,Down,Left} to change layout orientation
riverctl map normal Super Up send-layout-cmd rivertile "main-location top"
riverctl map normal Super Right send-layout-cmd rivertile "main-location right"
riverctl map normal Super Down send-layout-cmd rivertile "main-location bottom"
riverctl map normal Super Left send-layout-cmd rivertile "main-location left"

# Declare a passthrough mode. This mode has only a single mapping to return to
# normal mode. This makes it useful for testing a nested wayland compositor
riverctl declare-mode passthrough

# Mod+F11 to enter passthrough mode
riverctl map normal Super F11 enter-mode passthrough

# Mod+F11 to return to normal mode
riverctl map passthrough Super F11 enter-mode normal

# Various media key mapping examples for both normal and locked mode which do
# not have a modifier
for mode in normal locked; do
  # Eject the optical drive
  riverctl map $mode None XF86Eject spawn 'eject -T'

  # Control pulse audio volume with pamixer (https://github.com/cdemoulins/pamixer)
  riverctl map $mode None XF86AudioLowerVolume spawn "volume down"
  riverctl map $mode None XF86AudioRaiseVolume spawn "volume up"
  riverctl map $mode None XF86AudioMute spawn "volume mute"

  # Control MPRIS aware media players with playerctl (https://github.com/altdesktop/playerctl)
  riverctl map $mode None XF86AudioMedia spawn 'playerctl play-pause'
  riverctl map $mode None XF86AudioPlay spawn 'playerctl play-pause'
  riverctl map $mode None XF86AudioPrev spawn 'playerctl previous'
  riverctl map $mode None XF86AudioNext spawn 'playerctl next'

  # Control screen backlight brighness with light (https://github.com/haikarainen/light)
  # shellcheck disable=SC2016
  riverctl map $mode None XF86MonBrightnessDown spawn 'brightnessctl -q set 5%- && ( echo $((`brightnessctl get` * 100 / `brightnessctl m`)) > $XDG_RUNTIME_DIR/wob.sock )'
  # shellcheck disable=SC2016
  riverctl map $mode None XF86MonBrightnessUp spawn 'brightnessctl -q set +5% && ( echo $((`brightnessctl get` * 100 / `brightnessctl m`)) > $XDG_RUNTIME_DIR/wob.sock )'
  #riverctl map $mode None XF86MonBrightnessUp   spawn 'light -A 5'
  #riverctl map $mode None XF86MonBrightnessDown spawn 'light -U 5'
done

# Set repeat rate
riverctl set-repeat 50 300

# Make certain views start floating
riverctl float-filter-add app-id float
riverctl float-filter-add title "popup title with spaces"

# add ssd for some apps
riverctl rule-add -app-id 'com.mitchellh.ghostty' ssd
riverctl rule-add -app-id 'firefox' ssd

# warp the mouse
riverctl set-cursor-warp on-focus-change

riverctl border-width 1

riverctl default-layout rivertile
riverctl attach-mode bottom

if ! pgrep rivertile; then
  rivertile -main-ratio 0.5 -view-padding 2 -outer-padding 2
fi
