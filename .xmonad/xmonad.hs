-- Core
import XMonad
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import System.Exit
import Graphics.X11.Xlib
import Graphics.X11.ExtraTypes.XF86
--import IO (Handle, hPutStrLn)
import qualified System.IO
import XMonad.Actions.CycleWS
import Data.List
 
-- Prompts
import XMonad.Prompt
import XMonad.Prompt.Shell
 
-- Actions
import XMonad.Actions.MouseGestures
import XMonad.Actions.UpdatePointer
import XMonad.Actions.GridSelect
 
-- Utils
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.Loggers
import XMonad.Util.EZConfig
import XMonad.Util.Scratchpad
-- Hooks
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.Place
import XMonad.Hooks.EwmhDesktops

-- Layouts
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.DragPane
import XMonad.Layout.LayoutCombinators hiding ((|||))
import XMonad.Layout.DecorationMadness
import XMonad.Layout.TabBarDecoration
import XMonad.Layout.IM
import XMonad.Layout.Grid
import XMonad.Layout.Spiral
import XMonad.Layout.Mosaic
import XMonad.Layout.LayoutHints

import Data.Ratio ((%))
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.Spacing
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Gaps
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName

import qualified DBus as D
import qualified DBus.Client as D

import Config

defaults = def {
        terminal             = "urxvt"
        --, font                = "xft:Monospace:size=10"
        , normalBorderColor   = "black"
        , focusedBorderColor  = "orange"        
        , workspaces          = myWorkspaces
        , modMask             = mod4Mask  -- Use Super instead of Alt
        , borderWidth         = 2
        , startupHook         = setWMName "LG3D"
        , layoutHook          = myLayoutHook
        , manageHook          = myManageHook
        , handleEventHook     = fullscreenEventHook  -- для совместимости определёных приложений, java например(IntelliJ IDEA)
        } `additionalKeys` myKeys

myWorkspaces :: [String]
myWorkspaces =  [
--    " ^i(/home/petertr/.xmonad/icons/arch_10x10.xbm) "
--    , " ^i(/home/petertr/.xmonad/icons/arch.xbm) "
    "default"
    , "dev"
    , "web"
    , "apps"
    , "media"
--    , "im"
    ]
    ++ map show [6..9]

-- tab theme default
myTabConfig = def {
   activeColor          = "#6666cc"
  , activeBorderColor   = "#000000"
  , inactiveColor       = "#666666"
  , inactiveBorderColor = "#000000"
  , decoHeight          = 10
 }

-- Color of current window title in xmobar.
xmobarTitleColor = "#FFFFFF" --"#FFB6B0"

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = "#8AE234"

--myLayoutHook = spacing 6 $ gaps [(U,28),(D,6),(R,6),(L,6)] $ toggleLayouts (noBorders Full) $ 
--    smartBorders $ Mirror tiled ||| mosaic 2 [3,2]  ||| tabbed shrinkText myTabConfig
--      where 
--        tiled = Tall nmaster delta ratio
--        nmaster = 1
--        delta   = 3/100
--        ratio   = 3/5

myLayoutHook = smartBorders $ avoidStruts $ toggleLayouts (noBorders Full)
    (smartBorders (tiled ||| mosaic 2 [3,2] ||| Mirror tiled ||| tabbed shrinkText myTabConfig))
    where
        tiled   = layoutHints $ ResizableTall nmaster delta ratio []
        nmaster = 1
        delta   = 3/100
        ratio   = 3/5                              
                              
myManageHook :: ManageHook
myManageHook = composeAll . concat $
  [ [className =? c --> doF (W.shift "default")  | c <- myWorkG]
  , [className =? c --> doF (W.shift "dev")         | c <- myDev]
  , [className =? c --> doF (W.shift "web")         | c <- myWeb]
  , [className =? c --> doF (W.shift "apps")        | c <- myApps]
  , [className =? c --> doF (W.shift "media")       | c <- myMedia]
--  , [className =? c --> doF (W.shift "im")            | c <- myIM]
  , [manageDocks]
  ]
  where
  myWorkG = ["python"]
  myDev = ["Code", "RStudio"]
  myWeb = ["Firefox","Chromium"]
  myApps = ["Thunar", "Evince", "sublime_text", "fman"]
  myMedia = ["Steam","vlc", "Skype", "Deluge"]
  --myIM = ["pidgin"]
  
  --KP_Add KP_Subtract
myKeys = [
         ((mod4Mask, xK_Right), nextScreen)
         , ((mod4Mask, xK_Left ), prevScreen)
         , ((mod4Mask, xK_Down ), nextWS)
         , ((mod4Mask, xK_Up ), prevWS)
         , ((mod4Mask, xK_0 ), toggleWS)
         , ((mod4Mask .|. shiftMask, xK_Down), shiftToNext >> nextWS)
         , ((mod4Mask .|. shiftMask, xK_Up),   shiftToPrev >> prevWS)
         , ((mod4Mask .|. shiftMask, xK_f), shiftTo Next EmptyWS)  -- find a free workspace
--         , ((mod4Mask, xK_o), goToSelected defaultGSConfig)
--         , ((mod4Mask, xK_s), spawnSelected defaultGSConfig ["chromium","idea","gvim"])
      -- volume controls
         , ((0, xF86XK_AudioRaiseVolume), spawn "amixer sset Master 5%+ && ~/.xmonad/getvolume.sh > /tmp/.volume-pipe")
         , ((0, xF86XK_AudioLowerVolume), spawn "amixer sset Master 5%- && ~/.xmonad/getvolume.sh > /tmp/.volume-pipe")
         , ((0, xF86XK_AudioMute), spawn "amixer sset Master toggle && ~/.xmonad/getvolume.sh > /tmp/.volume-pipe") 
         , ((0, xF86XK_MonBrightnessDown), spawn "brightnessctl set 10%-")
         , ((0, xF86XK_MonBrightnessUp), spawn "brightnessctl set 10%+")
--         , ((mod4Mask, xK_p), spawn "dmenu_run -x 6 -y 8 -h 16 -w 1354")
         , ((mod4Mask, xK_p), spawn "rofi -show run -config .Xresources")
         , ((mod4Mask, xK_o), spawn "rofi -show window -config .Xresources")
--         , ((mod4Mask, xK_f), spawn "thunar")
--         , ((mod4Mask, xK_w), spawn "chromium")
--         , ((mod4Mask, xK_m), spawn "mocp")
--         , ((mod4Mask .|. shiftMask, xK_t), spawn "urxvt")
         ]              


main :: IO ()
main = do
  --spawn "~/.xmonad/getvolume.sh > /tmp/.volume-pipe"
  --xmproc <- spawnPipe "xmobar" --"i3status | xmobar -o -t \"%StdinReader%\" -c \"[Run StdinReader]\""  --"/usr/bin/xmobar" --  ~/.xmonad/xmobar.hs"
  xmproc <- spawnPipe "polybar example &"
  dbus <- D.connectSession
  -- Request access to the DBus name
  D.requestName dbus (D.busName_ "org.xmonad.Log")
      [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]
  xmonad $ docks $ ewmh $ defaults {
  logHook =  dynamicLogWithPP (myLogHook dbus) }
