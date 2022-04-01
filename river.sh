#!/bin/sh

# Set background and border color
riverctl background-color 0x1c1d21
riverctl border-color-focused 0xcbcdd2
riverctl border-color-unfocused 0x3f4044

riverctl map normal Mod4+Shift T spawn 'kitty --single-instance'
riverctl map normal Mod4+Shift W spawn 'gtk-launch firefox'
riverctl map normal Mod4+Shift V spawn 'gtk-launch code'
riverctl map normal Mod4+Shift+Control E spawn 'gtk-launch emacsclient'
riverctl map normal Mod4 D spawn 'wofi --show drun,run'
riverctl map normal Mod4+Shift+Control D spawn 'dark-mode toggle'

# Mod+Q to close the focused view
riverctl map normal Mod4+Shift Q close

# Mod+E to exit river
riverctl map normal Mod4+Shift E exit

# Mod+J and Mod+K to focus the next/previous view in the layout stack
riverctl map normal Mod4 J focus-view next
riverctl map normal Mod4 K focus-view previous
riverctl map normal Mod4 S focus-view next
riverctl map normal Mod4 W focus-view previous

# Mod+Shift+J and Mod+Shift+K to swap the focused view with the next/previous
# view in the layout stack
riverctl map normal Mod4+Shift J swap next
riverctl map normal Mod4+Shift K swap previous
riverctl map normal Mod4+Shift S swap next
riverctl map normal Mod4+Shift W swap previous

# Mod+Period and Mod+Comma to focus the next/previous output
riverctl map normal Mod4 Period focus-output next
riverctl map normal Mod4 Comma focus-output previous

# Mod+Shift+{Period,Comma} to send the focused view to the next/previous output
riverctl map normal Mod4+Shift Period send-to-output next
riverctl map normal Mod4+Shift Comma send-to-output previous

# Mod+Return to bump the focused view to the top of the layout stack
riverctl map normal Mod4 A zoom

# Mod+H and Mod+L to decrease/increase the main ratio of rivertile(1)
riverctl map normal Mod4 H send-layout-cmd rivertile "main-ratio -0.05"
riverctl map normal Mod4 L send-layout-cmd rivertile "main-ratio +0.05"

# Mod+Shift+H and Mod+Shift+L to increment/decrement the main count of rivertile(1)
riverctl map normal Mod4+Shift H send-layout-cmd rivertile "main-count +1"
riverctl map normal Mod4+Shift L send-layout-cmd rivertile "main-count -1"

# Mod+Alt+{H,J,K,L} to move views
riverctl map normal Mod4+Mod1 H move left 100
riverctl map normal Mod4+Mod1 J move down 100
riverctl map normal Mod4+Mod1 K move up 100
riverctl map normal Mod4+Mod1 L move right 100

# Mod+Alt+Control+{H,J,K,L} to snap views to screen edges
riverctl map normal Mod4+Mod1+Control H snap left
riverctl map normal Mod4+Mod1+Control J snap down
riverctl map normal Mod4+Mod1+Control K snap up
riverctl map normal Mod4+Mod1+Control L snap right

# Mod+Alt+Shif+{H,J,K,L} to resize views
riverctl map normal Mod4+Mod1+Shift H resize horizontal -100
riverctl map normal Mod4+Mod1+Shift J resize vertical 100
riverctl map normal Mod4+Mod1+Shift K resize vertical -100
riverctl map normal Mod4+Mod1+Shift L resize horizontal 100

# Mod + Left Mouse Button to move views
# riverctl map-pointer normal Mod4 BTN_LEFT move-view

# Mod + Right Mouse Button to resize views
# riverctl map-pointer normal Mod4 BTN_RIGHT resize-view

for i in $(seq 1 9); do
  tags=$((1 << ($i - 1)))

  # Mod+[1-9] to focus tag [0-8]
  riverctl map normal Mod4 $i set-focused-tags $tags

  # Mod+Shift+[1-9] to tag focused view with tag [0-8]
  riverctl map normal Mod4+Shift $i set-view-tags $tags

  # Mod+Ctrl+[1-9] to toggle focus of tag [0-8]
  riverctl map normal Mod4+Control $i toggle-focused-tags $tags

  # Mod+Shift+Ctrl+[1-9] to toggle tag [0-8] of focused view
  riverctl map normal Mod4+Shift+Control $i toggle-view-tags $tags
done

# Mod+0 to focus all tags
# Mod+Shift+0 to tag focused view with all tags
all_tags=$(((1 << 32) - 1))
riverctl map normal Mod4 0 set-focused-tags $all_tags
riverctl map normal Mod4+Shift 0 set-view-tags $all_tags

# Mod+Space to toggle float
riverctl map normal Mod4+Shift Space toggle-float

# Mod+F to toggle fullscreen
riverctl map normal Mod4 F toggle-fullscreen

# Mod+{Up,Right,Down,Left} to change layout orientation
riverctl map normal Mod4 Up send-layout-cmd rivertile "main-location top"
riverctl map normal Mod4 Right send-layout-cmd rivertile "main-location right"
riverctl map normal Mod4 Down send-layout-cmd rivertile "main-location bottom"
riverctl map normal Mod4 Left send-layout-cmd rivertile "main-location left"

# Declare a passthrough mode. This mode has only a single mapping to return to
# normal mode. This makes it useful for testing a nested wayland compositor
riverctl declare-mode passthrough

# Mod+F11 to enter passthrough mode
riverctl map normal Mod4 F11 enter-mode passthrough

# Mod+F11 to return to normal mode
riverctl map passthrough Mod4 F11 enter-mode normal

# Various media key mapping examples for both normal and locked mode which do
# not have a modifier
for mode in normal locked; do
  # Eject the optical drive
  riverctl map $mode None XF86Eject spawn 'eject -T'

  # Control pulse audio volume with pamixer (https://github.com/cdemoulins/pamixer)
  riverctl map $mode None XF86AudioRaiseVolume spawn "amixer -D pipewire sset Master 5%+ | grep 'Front Left:' | awk '{print \$5}' | sed -r 's/(\[|\]|%)//g' >> $XDG_RUNTIME_DIR/wob.fifo"
  riverctl map $mode None XF86AudioLowerVolume spawn "amixer -D pipewire sset Master 5%- | grep 'Front Left:' | awk '{print \$5}' | sed -r 's/(\[|\]|%)//g' >> $XDG_RUNTIME_DIR/wob.fifo"
  riverctl map $mode None XF86AudioMute spawn "amixer -D pipewire sset Master toggle"

  # Control MPRIS aware media players with playerctl (https://github.com/altdesktop/playerctl)
  riverctl map $mode None XF86AudioMedia spawn 'playerctl play-pause'
  riverctl map $mode None XF86AudioPlay spawn 'playerctl play-pause'
  riverctl map $mode None XF86AudioPrev spawn 'playerctl previous'
  riverctl map $mode None XF86AudioNext spawn 'playerctl next'

  # Control screen backlight brighness with light (https://github.com/haikarainen/light)
  riverctl map $mode None XF86MonBrightnessDown spawn 'brightnessctl -q set 5%- && ( echo $((`brightnessctl get` * 100 / `brightnessctl m`)) > $XDG_RUNTIME_DIR/wob.fifo )'
  riverctl map $mode None XF86MonBrightnessUp spawn 'brightnessctl -q set +5% && ( echo $((`brightnessctl get` * 100 / `brightnessctl m`)) > $XDG_RUNTIME_DIR/wob.fifo )'
  #riverctl map $mode None XF86MonBrightnessUp   spawn 'light -A 5'
  #riverctl map $mode None XF86MonBrightnessDown spawn 'light -U 5'
done

# Set repeat rate
riverctl set-repeat 50 300

# Make certain views start floating
riverctl float-filter-add app-id float
riverctl float-filter-add title "popup title with spaces"

# Set app-ids and titles of views which should use client side decorations
riverctl csd-filter-add app-id "gedit"

riverctl set-repeat 100 190
riverctl input pointer-1452:613:Apple_Inc._Magic_Trackpad natural-scroll enabled
riverctl input pointer-1452:613:Apple_Inc._Magic_Trackpad tap enabled
riverctl input pointer-1452:613:Apple_Inc._Magic_Trackpad tap-button-map left-right-middle
# riverctl input 1739:52619:SYNA8004:00_06CB:CD8B_Touchpad events disabled
riverctl input pointer-1739-52619-SYNA8004:00_06CB:CD8B_Touchpad natural-scroll enabled
riverctl input pointer-1739-52619-SYNA8004:00_06CB:CD8B_Touchpad tap enabled
riverctl input pointer-1739-52619-SYNA8004:00_06CB:CD8B_Touchpad tap-button-map left-right-middle
riverctl focus-follows-cursor normal

# systemd

systemctl --user import-environment
systemctl --user start river-session.target

# Set and exec into the default layout generator, rivertile.
# River will send the process group of the init executable SIGTERM on exit.
riverctl default-layout rivertile

if ! pgrep rivertile; then
  exec rivertile -main-ratio 0.5 -view-padding 2 -outer-padding 2
fi
