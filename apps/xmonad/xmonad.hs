import XMonad
import XMonad.Util.EZConfig
import XMonad.Config.Desktop

main = xmonad $ desktopConfig
  { terminal    = "kitty"
  , modMask     = mod4Mask
  , borderWidth = 3
  }
  `additionalKeysP`
  [ ("M-d", spawn "systemd-cat --identifier=rofi rofi -show drun -dpi 192") ]
