import XMonad
import XMonad.Util.EZConfig
import XMonad.Config.Desktop

main = xmonad $ desktopConfig
  { terminal    = "kitty"
  , modMask     = mod4Mask
  -- , borderWidth = 3
  , normalBorderColor = "#3E4B59"
  , focusedBorderColor = "#E6E1CF"
  }
  `additionalKeysP`
  [ ("M-d", spawn "systemd-cat --identifier=rofi rofi -show drun -dpi 192")
  , ("M-S-t", spawn "systemd-cat --identifier=kitty kitty --single-instance")
  ]
