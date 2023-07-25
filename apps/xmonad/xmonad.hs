{-# LANGUAGE ImportQualifiedPost #-}

import System.Exit
import XMonad
import XMonad.Actions.CopyWindow
import XMonad.Actions.CycleWS
import XMonad.Actions.UpdatePointer
import XMonad.Config.Desktop
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import XMonad.Operations
import XMonad.StackSet qualified as W
import XMonad.Util.Cursor
import XMonad.Util.EZConfig

spawner exec = spawn ("systemd-cat --identifier=" ++ app ++ " " ++ exec)
  where
    app = head $ words exec

dotWorkspaces = map show [1 .. 9]

dotKeys =
  [ ("<XF86AudioLowerVolume>", spawner "$HOME/.dotfiles/bin/volume down"),
    ("<XF86AudioMedia>", spawner "playerctl play-pause"),
    ("<XF86AudioMute>", spawner "$HOME/.dotfiles/bin/volume mute"),
    ("<XF86AudioNext>", spawner "playerctl next"),
    ("<XF86AudioPlay>", spawner "playerctl play-pause"),
    ("<XF86AudioPrev>", spawner "playerctl previous"),
    ("<XF86AudioRaiseVolume>", spawner "$HOME/.dotfiles/bin/volume up"),
    ("<XF86MonBrightnessDown>", spawner "brightnessctl -q set 5%-"),
    ("<XF86MonBrightnessUp>", spawner "brightnessctl -q set +5%"),
    ("M-a", windows $ W.swapMaster . W.focusDown),
    ("M-d", spawner "rofi -show drun"),
    ("M-S-d", spawner "rofi -show emoji"),
    ("M-C-S-q", io exitSuccess),
    ("M-S-q", kill),
    ("M-C-S-t", spawner "$HOME/.dotfiles/bin/monitor-toggle.sh"),
    ("M-S-t", spawner "kitty --single-instance"),
    ("M-s", windows W.focusDown),
    ("M-w", windows W.focusUp),
    ("M-`", toggleWS)
    -- M-t will return floating to tiled
  ]
    ++ [("M-C-S-" ++ show i, windows $ copy ws) | (i, ws) <- zip [1 .. 9] dotWorkspaces]

dotLayouts = avoidStruts (Tall 1 (3 / 100) (2 / 3)) ||| noBorders Full

dotLogHook = updatePointer (0.5, 0.5) (0, 0) <> logHook desktopConfig

dotManageHook =
  manageHook desktopConfig
    <> manageDocks
    <> composeAll
      [ isDialog --> doCenterFloat,
        title =? "Picture-in-Picture" --> doFloat,
        title =? "Picture-in-Picture" --> doF copyToAll,
        isFullscreen --> doFullFloat
      ]

dotStartupHook = setDefaultCursor xC_left_ptr <> spawn "xsetroot -cursor_name left_ptr" -- this is a hack, i don't know why i need it

main =
  xmonad
    $ docks
    $ ewmhFullscreen
      . ewmh
    $ desktopConfig
      { terminal = "kitty",
        modMask = mod4Mask,
        -- , borderWidth = 3
        normalBorderColor = "#3E4B59",
        focusedBorderColor = "#E6E1CF",
        logHook = dotLogHook,
        startupHook = dotStartupHook,
        manageHook = dotManageHook,
        layoutHook = smartBorders $ desktopLayoutModifiers dotLayouts
      }
      `additionalKeysP` dotKeys
