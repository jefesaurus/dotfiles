import XMonad
import XMonad.Layout.Spacing
import Graphics.X11.ExtraTypes.XF86
import XMonad.Util.EZConfig
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run
import System.IO
import qualified XMonad.StackSet as W
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders

layoutOne = tiled ||| Mirror tiled ||| Full
  where
    tiled = spacing 3 $ Tall nmaster delta ratio
    nmaster = 1   --number of windows in in master pane
    ratio = 2/3   --default proportion for master pane
    delta = 2/100 --pane increment percentage

myManageHook = composeAll
  [ className =? "Xmessage"   --> doFloat
  , isFullscreen --> (doF W.focusDown <+> doFullFloat)
  , className =? "Vlc" --> doCenterFloat
  , className =? "Gimp" --> doCenterFloat 
  , manageDocks
  ]

main = do
  xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmobarrc"
  xmonad $ defaultConfig
    {modMask = mod4Mask
    ,normalBorderColor = "#464646"
    ,focusedBorderColor = "#ED5235"
    ,manageHook = myManageHook <+> manageHook defaultConfig
    ,layoutHook = avoidStruts $ smartBorders layoutOne
    , handleEventHook    = fullscreenEventHook 
    ,logHook = dynamicLogWithPP xmobarPP
      {ppOutput = hPutStrLn xmproc
      ,ppCurrent = xmobarColor "#ee9a00" "" . wrap "[" "]"
      ,ppTitle = const "" 
      ,ppLayout = const "" -- todisable the layout info on xmobar
      }
    }`additionalKeys`
    [(( mod4Mask, xK_c), spawn "chrome") --open chrome
    ,(( mod4Mask, xK_t), spawn "roxterm") --open a new terminal
    ,(( mod4Mask, xK_m), spawn "thunderbird") --open mail client 
    ,(( 0, xF86XK_AudioRaiseVolume), spawn "amixer -c 0 -- sset Master playback 5+")
    ,(( 0, xF86XK_AudioLowerVolume), spawn "amixer -c 0 -- sset Master playback 5-")
    ,(( 0, xF86XK_Launch1), spawn "chrome --incognito")
    , ((mod4Mask, xK_s), withFocused $ windows . W.sink) -- %! Push window back into tiling
    , ((mod4Mask, xK_w), kill) -- %! Close the focused window
    ]

    --121 XF86AudioMute
    --160 XF86ScreenSaver
    --151 XF86Sleep
    --246 XF86WLAN
    --235 XF86Display
    --232 XF86MonBrightnessDown
    --233 XF86MonBrightnessUp
    --173 XF86AudioPrev
    --172 XF86AudioPlay
    --171 XF86AudioNext
    --156 XF86Launch1


