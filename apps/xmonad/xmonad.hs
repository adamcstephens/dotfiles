import System.Exit
import XMonad
import XMonad.Actions.CopyWindow
import XMonad.Actions.UpdatePointer
import XMonad.Config.Desktop
import XMonad.Operations
import qualified XMonad.StackSet as W
import XMonad.Util.Cursor
import XMonad.Util.EZConfig

spawner exec = spawn ("systemd-cat --identifier=" ++ app ++ " " ++ exec)
  where
    app = head $ words exec

dotWorkspaces = map show [1 .. 9]

dotKeys =
  [ ("<XF86AudioLowerVolume>", spawner "volume down"),
    ("<XF86AudioMedia>", spawner "playerctl play-pause"),
    ("<XF86AudioMute>", spawner "volume mute"),
    ("<XF86AudioNext>", spawner "playerctl next"),
    ("<XF86AudioPlay>", spawner "playerctl play-pause"),
    ("<XF86AudioPrev>", spawner "playerctl previous"),
    ("<XF86AudioRaiseVolume>", spawner "volume up"),
    ("<XF86MonBrightnessDown>", spawner "brightnessctl -q set 5%-"),
    ("<XF86MonBrightnessUp>", spawner "brightnessctl -q set +5%"),
    ("M-a", windows $ W.swapMaster . W.focusDown),
    ("M-d", spawner "rofi -show drun"),
    ("M-S-d", spawner "rofi -show emoji"),
    ("M-C-S-q", io exitSuccess),
    ("M-S-q", kill),
    ("M-S-t", spawner "kitty --single-instance"),
    ("M-s", windows W.focusDown),
    ("M-w", windows W.focusUp)
  ]
    ++ [("M-C-S-" ++ show i, windows $ copy ws) | (i, ws) <- zip [1 .. 9] dotWorkspaces]

main =
  xmonad $
    desktopConfig
      { terminal = "kitty",
        modMask = mod4Mask,
        -- , borderWidth = 3
        normalBorderColor = "#3E4B59",
        focusedBorderColor = "#E6E1CF",
        logHook = updatePointer (0.5, 0.5) (0, 0) <> logHook desktopConfig,
        startupHook = setDefaultCursor xC_left_ptr <> spawn "xsetroot -cursor_name left_ptr" -- this is a hack, i don't know why i need it
      }
      `additionalKeysP` dotKeys
