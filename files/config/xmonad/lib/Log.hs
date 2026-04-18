------------------------------------------------------------------------
-- Log
------------------------------------------------------------------------
module Log where
import Definitions
import Keybinds
import Layouts
import AutoStart

------------------------------------------------------------------------
-- Imports
------------------------------------------------------------------------
-- Basics
import XMonad
import Data.Monoid
import Data.List (intercalate)
import Data.Char (isSpace)
import Data.Tree
import System.Exit
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import Control.Monad
import XMonad.ManageHook (className)
import XMonad.Prelude (when)
-- Layouts
import XMonad.Layout.Spiral
import XMonad.Layout.Renamed
import XMonad.Layout.Tabbed
import XMonad.Layout.Accordion
import XMonad.Layout.ThreeColumns
import XMonad.Layout.MultiColumns
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Layout.Fullscreen
import XMonad.Layout.LayoutModifier
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.ResizableTile
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Layout.Simplest
import XMonad.Layout.Minimize
import XMonad.Layout.TwoPane
import XMonad.Layout.Grid
import XMonad.Layout.CircleEx
import XMonad.Layout.ZoomRow
import XMonad.Layout.LimitWindows
import qualified XMonad.Layout.BoringWindows as BW
-- Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory
import XMonad.Hooks.FadeWindows (isUnfocused)
-- Utils
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce
import XMonad.Util.Run (runProcessWithInput)
import XMonad.Util.Loggers
import XMonad.Util.NamedActions
import XMonad.Util.Cursor (setDefaultCursor)
import qualified XMonad.Util.ExtensibleState as XS
import XMonad.Util.NamedScratchpad
-- Actions
import XMonad.Actions.FloatKeys
import XMonad.Actions.WithAll
import XMonad.Actions.CycleWS (screenBy, toggleWS, moveTo, WSType(Not), emptyWS, Direction1D(Next, Prev))
import XMonad.Actions.Warp
import XMonad.Actions.MouseResize
import XMonad.Actions.WithAll (sinkAll)
import XMonad.Actions.Minimize
import qualified XMonad.Actions.Search as S
import XMonad.Actions.Submap (submap, submapDefault)
import XMonad.Actions.ShowText
import XMonad.Actions.PhysicalScreens
import qualified XMonad.Actions.TreeSelect as TS
import XMonad.Actions.TreeSelect (TSNode(..))
import XMonad.Actions.OnScreen (viewOnScreen)
import XMonad.Actions.UpdatePointer
-- X11
import Graphics.X11.Xlib (xC_left_ptr)
import Graphics.X11.Xlib (warpPointer)
import Graphics.X11.Xlib.Extras (none, getWindowAttributes, wa_width, wa_height)
-- Prompt
import XMonad.Prompt
import XMonad.Prompt.ConfirmPrompt

------------------------------------------------------------------------
-- Log Hook
------------------------------------------------------------------------
-- Disable Alt_L if Arcan is Focused
myArcanDisableAltHook :: X ()
myArcanDisableAltHook = withFocused $ \w -> do
  cls <- runQuery className w
  current <- XS.get
  if cls == "arcan_sdl"
    then when (current /= AltDisabled) $ do
      spawn "xmodmap -e 'keycode 64= NoSymbol'"
      XS.put AltDisabled
   else when (current /= AltEnabled) $ do
      spawn "xmodmap -e 'keycode 64= Alt_L'"
      XS.put AltEnabled

-- Extra Log Hook
myExtraLogHook = do
  myArcanDisableAltHook

-- Log Hook
myLogHook = do
  dynamicLogWithPP $ def
     { ppOutput = \x -> do
       appendFile "/tmp/.xmonad-layout-log" (x ++ "\n")
     , ppCurrent = wrap "[" "]"
     , ppLayout = id
     , ppSep = " | "
     , ppOrder = \(ws:l:t:_) -> [l]
     }
  -- myExtraLogHook
