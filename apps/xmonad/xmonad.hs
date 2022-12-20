import XMonad
import XMonad.Actions.UpdatePointer
import XMonad.Config.Desktop
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig

main =
  xmonad $
    desktopConfig
      { terminal = "kitty",
        modMask = mod4Mask,
        -- , borderWidth = 3
        normalBorderColor = "#3E4B59",
        focusedBorderColor = "#E6E1CF",
        logHook = updatePointer (0.5, 0.5) (0, 0)
      }
      `additionalKeysP` [ ("M-d", spawn "systemd-cat --identifier=rofi rofi -show drun -dpi 192"),
                          ("M-S-t", spawn "systemd-cat --identifier=kitty kitty --single-instance"),
                          ("M-a", windows $ W.swapMaster . W.focusDown)
                        ]
