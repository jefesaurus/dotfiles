import XMonad
import XMonad.Hooks.SetWMName
import XMonad.Layout.Grid
import XMonad.Layout.ResizableTile
import XMonad.Layout.IM
import XMonad.Layout.ThreeColumns
import XMonad.Layout.NoBorders
import XMonad.Layout.Circle
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.Fullscreen
import XMonad.Layout.ToggleLayouts
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Hooks.DynamicLog
import XMonad.Actions.Plane
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ICCCMFocus
import XMonad.Hooks.EwmhDesktops
import Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import Data.Ratio ((%))

{-
  Xmonad configuration variables. These settings control some of the
  simpler parts of xmonad's behavior and are straightforward to tweak.
-}

myModMask            = mod4Mask       -- changes the mod key to "super"
myFocusedBorderColor = "#ED5235"      -- color of focused border
myNormalBorderColor  = "#464646"      -- color of inactive border
myBorderWidth        = 1              -- width of border around windows
myTerminal           = "lxterminal"   -- which terminal software to use


myWorkspaces =
  [
    "7",  "8", "9",
    "4",  "5", "6",
    "1",  "2", "3",
    ":p", "0",  "RAGE", "???"
  ]

startupWorkspace = "1"  -- which workspace do you want to be on after launch?

{-
  Layout configuration. In this section we identify which xmonad
  layouts we want to use. I have defined a list of default
  layouts which are applied on every workspace, as well as
  special layouts which get applied to specific workspaces.

  Note that all layouts are wrapped within "avoidStruts". What this does
  is make the layouts avoid the status bar area at the top of the screen.
  Without this, they would overlap the bar. You can toggle this behavior
  by hitting "super-b" (bound to ToggleStruts in the keyboard bindings
  in the next section).
-}

-- Define group of default layouts used on most screens, in the
-- order they will appear.
-- "smartBorders" modifier makes it so the borders on windows only
-- appear if there is more than one visible window.
-- "avoidStruts" modifier makes it so that the layout provides
-- space for the status bar at the top of the screen.
defaultLayouts = toggleLayouts (noBorders Full) $ smartBorders(avoidStruts(
  -- ResizableTall layout has a large master window on the left,
  -- and remaining windows tile on the right. By default each area
  -- takes up half the screen, but you can resize using "super-h" and
  -- "super-l".
  ResizableTall 1 (3/100) (1/2) []

  -- Full layout makes every window full screen. When you toggle the
  -- active window, it will bring the active window to the front.
  ||| noBorders Full))


myLayouts = defaultLayouts

myKeyBindings =
  [
    -- Window management
    ((myModMask, xK_b), sendMessage ToggleStruts)
    , ((myModMask, xK_f), sendMessage ToggleLayout)
    , ((myModMask, xK_s), withFocused $ windows . W.sink)

    -- Quick launch
    , ((myModMask, xK_t), spawn "lxterminal")
    , ((myModMask, xK_c), spawn "chromium-browser")
    , ((myModMask, xK_space), spawn "dmenu_run")
    , ((0, xF86XK_Launch1), spawn "chromium-browser --incognito")
    , ((myModMask, xK_x), kill)
    , ((myModMask, xK_n), refresh)

    -- Hardware management
    , ((0, xF86XK_AudioLowerVolume), spawn "amixer -q set Master 5-")
    , ((0, xF86XK_AudioRaiseVolume), spawn "amixer -q set Master 5+")
    , ((0, xF86XK_AudioMute), spawn "amixer -D pulse set Master 1+ toggle")
    , ((0, xF86XK_Display), spawn "~/.xmonad/bin/set-screens.sh")
  ]


myManagementHooks :: [ManageHook]
myManagementHooks = [
  resource =? "stalonetray" --> doIgnore
  ]


{-
  Workspace navigation keybindings. This is probably the part of the
  configuration I have spent the most time messing with, but understand
  the least. Be very careful if messing with this section.
-}

numKeys =
  [
    xK_7, xK_8, xK_9
    , xK_4, xK_5, xK_6
    , xK_1, xK_2, xK_3
    , xK_grave, xK_0, xK_minus, xK_equal
  ]

-- Here, some magic occurs that I once grokked but has since
-- fallen out of my head. Essentially what is happening is
-- that we are telling xmonad how to navigate workspaces,
-- how to send windows to different workspaces,
-- and what keys to use to change which monitor is focused.
myKeys = myKeyBindings ++
  [
    ((m .|. myModMask, k), windows $ f i)
       | (i, k) <- zip myWorkspaces numKeys
       , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
  ] ++
  M.toList (planeKeys myModMask (Lines 4) Finite) ++
  [
    ((m .|. myModMask, key), screenWorkspace sc
      >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_w, xK_e, xK_r] [1,0,2]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
  ]


{-
  Here we actually stitch together all the configuration settings
  and run xmonad.
-}

main = do
  xmonad $ withUrgencyHook NoUrgencyHook $ defaultConfig {
    focusedBorderColor = myFocusedBorderColor
  , normalBorderColor = myNormalBorderColor
  , terminal = myTerminal
  , borderWidth = myBorderWidth
  , layoutHook = myLayouts
  , workspaces = myWorkspaces
  , modMask = myModMask
  , handleEventHook = XMonad.Hooks.EwmhDesktops.fullscreenEventHook
  , startupHook = do
      setWMName "LG3D"
      windows $ W.greedyView startupWorkspace
      spawn "~/.xmonad/startup-hook"
  , manageHook = manageHook defaultConfig
      <+> composeAll myManagementHooks
      <+> manageDocks
  }
    `additionalKeys` myKeys
