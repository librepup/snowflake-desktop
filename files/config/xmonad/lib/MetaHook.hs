------------------------------------------------------------------------
-- Main
------------------------------------------------------------------------
module MetaHook where
import Definitions
import qualified Definitions as DEFS
import Keybinds
import Layouts
import AutoStart
import Log
import WindowRules
import UserAdditions

------------------------------------------------------------------------
-- Imports
------------------------------------------------------------------------
-- Basics
import XMonad
import XMonad.Operations
import Data.Monoid
import Data.List (intercalate, intersect)
import Data.Char (isSpace)
import Data.Tree
import Data.Ratio ((%))
import System.Exit
import System.IO (readFile, writeFile, Handle, hPutStrLn, hGetContents)
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import Control.Monad
import Control.Monad (when)
import Control.Exception (catch, IOException)
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
import XMonad.Hooks.ManageHelpers (isInProperty, doLower, doHideIgnore)
import XMonad.Hooks.ManageDocks (avoidStruts, docksStartupHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.Focus
import XMonad.Hooks.Focus (keepFocus, keepWorkspace, switchFocus, liftQuery, manageFocus, FocusHook(..), FocusQuery(..))
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory
import XMonad.Hooks.FadeWindows
-- Utils
import XMonad.Util.EZConfig
import XMonad.Util.WindowProperties
import XMonad.Util.WindowProperties (hasProperty)
import XMonad.Util.EZConfig (additionalKeys)
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
import Graphics.X11.Xlib
import Graphics.X11.Xlib (xC_left_ptr)
import Graphics.X11.Xlib (warpPointer)
import Graphics.X11.Xlib.Extras
import Graphics.X11.Xlib.Extras (none, getWindowAttributes, wa_width, wa_height)
import Graphics.X11.Types
-- Prompt
import XMonad.Prompt
import XMonad.Prompt.ConfirmPrompt

isShijima = (stringProperty "_NET_WM_NAME" =? "Shijima-Qt"
         <&&> isInProperty "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_UTILITY")


focusTickleHook e@(ClientMessageEvent {ev_window = w}) = do
  isS <- runQuery isShijima w
  if isS then return (All False) else return (All True)

focusTickleHook _ = return (All True)

------------------------------------------------------------------------
-- Main
------------------------------------------------------------------------
main :: IO ()
main = do
  rawTheme <- catch (readFile "/home/puppy/.xmonad/currentTheme")
                  (\(_ :: IOException) -> return "numi")

  let themeName = filter (`notElem` "\n\r") rawTheme
  let (activeTabTheme, activeColorScheme, activeXPConfig) = case themeName of
        "elXoX" -> (elXoXTabTheme, elXoXColorscheme, elXoXXPConfig)
        "mori" -> (moriTabTheme, moriColorscheme, moriXPConfig)
        "camila" -> (camilaTabTheme, camilaColorscheme, camilaXPConfig)
        "gigi" -> (gigiTabTheme, gigiColorscheme, gigiXPConfig)
        "numi" -> (numiTabTheme, numiColorscheme, numiXPConfig)
        _ -> (numiTabTheme, numiColorscheme, numiXPConfig)

  xmonad
     . ewmhFullscreen
     . ewmh
     . docks
     $ def {
        terminal           = myTerminal
        , focusFollowsMouse  = True
        , clickJustFocuses   = False
        , borderWidth        = myBorderWidth
        , modMask            = myModMask
        , workspaces         = myWorkspaces
        -- normalBorderColor  = myNormalBorderColor,
        -- focusedBorderColor = myFocusedBorderColor,
        , normalBorderColor  = normal activeColorScheme
        , focusedBorderColor = DEFS.focused activeColorScheme
        , keys               = \c -> myKeys activeTabTheme activeXPConfig c
        , mouseBindings      = myMouseBindings
        , layoutHook         = myLayoutHook activeTabTheme
        , manageHook         = myManageHook
                          <+> namedScratchpadManageHook myScratchpads
                          <+> manageHook def
        , handleEventHook    = fadeWindowsEventHook
                          <+> handleEventHook def
                          <+> focusTickleHook
        , startupHook        = myStartupHook
        , logHook            = fadeWindowsLogHook myFadeHook <+> myLogHook
     }
