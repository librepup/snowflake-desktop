------------------------------------------------------------------------
-- WindowRules
------------------------------------------------------------------------
module WindowRules where
import Definitions
import Keybinds
import Layouts
import AutoStart
import Log

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
import XMonad.ManageHook (className, composeAll, liftX)
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
import XMonad.Hooks.ManageHelpers (doLower, doHideIgnore, isFullscreen)
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.Focus
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory
import XMonad.Hooks.FadeWindows (isUnfocused)
-- Utils
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce
import XMonad.Util.Run (runProcessWithInput)
import XMonad.Util.Loggers
import XMonad.Util.WindowProperties
import XMonad.Util.NamedActions
import XMonad.Util.Cursor (setDefaultCursor)
import qualified XMonad.Util.ExtensibleState as XS
import XMonad.Util.NamedScratchpad
-- Actions
import XMonad.Actions.FloatKeys
import XMonad.Actions.WithAll
import XMonad.Actions.GridSelect
import XMonad.Actions.CycleWS (screenBy, toggleWS, moveTo, WSType(Not), emptyWS, Direction1D(Next, Prev))
import XMonad.Actions.Warp
import XMonad.Actions.CopyWindow
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
import Graphics.X11.Xlib
import Graphics.X11.Xlib.Extras
import Graphics.X11.Xlib.Extras (none, getWindowAttributes, wa_width, wa_height)
import Graphics.X11.Types
-- Prompt
import XMonad.Prompt
import XMonad.Prompt.ConfirmPrompt

(<&?>) :: Maybe Bool -> Maybe Bool -> Maybe Bool
(<&?>) (Just True) y = y
(<&?>) (Just False) _ = Just False
(<&?>) Nothing _      = Nothing
infixl 1 <&?>

------------------------------------------------------------------------
-- Window Rules
------------------------------------------------------------------------
myManageHook = composeAll
    [ (className =? "discord" <||>
       className =? "goofcord" <||>
       className =? "vesktop")
        -->                                                        -- Move "discord" and "vesktop" to Workspace 2.
          doShift "2"
    , title =? "FLOAT_MP"                 --> doCenterFloat        -- Float and Center Windows where Title equals "FLOAT_MP".
    , title =? "Volume Control"           --> doFloat              -- Float Volume Control Windows.
    , title =? "Lautstärkeregler"         --> doFloat              -- ...
    , isDialog                            --> doCenterFloat        -- Float and Center Dialog Windows.
    , (className =? "emote" <||>
       title =? "emote")
      -->                                                          -- Move "emote" to the Cursor.
        doFloat >> liftX (spawn moveWindowToCursorCommand) >> idHook
    , (title =? "vicinae" <||>
       className =? "vicinae")
      -->                                                          -- Focus and Warp Mouse to "vicinae" Window.
        (doFocus <+> doWarp)
    , (title =? "FLOAT_ME_NOW" <||>
       className =? "feh")
      -->                                                          -- Float and Move "FLOAT_ME_NOW" Windows.
        doRectFloat (W.RationalRect 0.15 0.1 0.7 0.8)
    , title =? "Library"                  --> doCenterFloat        -- Center Float Browser Library.
    , (className =? "Steam" <||>
       title =? "Steam")                  -->                      -- Move "Steam" to Workspace 2.
      doShift "2"
    , (className =? "weston" <||>
       className =? "weston-1" <||>
       className =? "Weston Compositor")  -->                      -- Float and Fullscreen Weston Window.
      doFullFloat
    , (className =? "eww" <||>
       className =? "Eww")                -->                      -- Move EWW Windows below all other Windows.
      doIgnore <+> doLower
    , className =? "equibop"              --> doShift "2"          -- Move "equibop" to Workspace 2.
    , className =? "Ark"                  --> doFloat              -- Float Ark Archiver Window.
    , isDialog                            -->                      -- Stop Dialogues from Stealing Focus and Reshuffling Tab Stack Order.
        doF id <+> doF W.shiftMaster
    , title =? "Media viewer"             --> doFloat              -- Float Telegram Media Viewer Window.
    , className =? "floorp"               --> doShift "2"          -- Send Floorp Browser to Workspace 2.
    , title =? "osu!"                     --> doShift "\xF0B82"    -- Move osu!stable to the "Games" Workspace.
    , className =? "notitg-v4.9.1.exe"    --> doShift "\xF0B82"
    , className =? "Quaver"               --> doShift "\xF0B82"    -- Move Quaver to the "Games" Workspace.
    , title =? "NormCap [0]"
      -->
        doShift "1"
        <+> doFullFloat
        <+> doFocus
    , title =? "NormCap [1]"
      -->
        doShift "2"
        <+> doFullFloat
    , title =? "Waypaper"                 -->                      -- Float, Center, and Resize Waypaper Windows.
      doRectFloat centerAndSizeTo840x440
    , className =? "krita"                --> doShift "3"
    , className =? "ulauncher"
      <||> title =? "Ulauncher - Application Launcher"
    --> hasBorder False
    , className =? "viewnior"
      <||> className =? "Viewnior"
      -->
        doCenterFloat
    , title =? "Krita - Edit Text — Krita"
      -->
        doFloat
    , className =? "xmonad-shijima-class-group"
      -->
        doIgnore
        <+> doF W.focusDown
        <+> hasBorder False
        <+> doRaise
        <+> doFloat
    , isShijima
      <||> className =? "Shijima-Qt"
      <&&> isInProperty "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_UTILITY"
      -->
        doIgnore
        <+> doF W.focusDown
        <+> doShift "1"
        <+> hasBorder False
        <+> doRaise
        <+> doFloat
    -- , className =? "Shijima-Qt"
    --   <&&> isInProperty "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_UTILITY"
    --   <||> netWmName =? "Shijima-Qt"
    --   <||> isShijima
    --   --> doIgnore
    --   <+> doFloat
    --   <+> hasBorder False
    --   <+> doLower
    --   <+> doF W.focusDown
    --   <+> doSideFloat NW
    -- , (liftX $ withWindowSet (return . (== "9") . W.currentTag)) --> doFloat <+> doSink
    ]
  where
    isShijima = (stringProperty "_NET_WM_NAME" =? "Shijima-Qt"
             <&&> isInProperty "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_UTILITY")
    netWmWindowType = stringProperty "_NET_WM_WINDOW_TYPE"
    netWmName = stringProperty "_NET_WM_NAME"
    moveWindowToCursorCommand =
      "if [[ $(xdotool getmouselocation --shell | grep Y= | cut -d'=' -f2) -gt 800 ]]; then " ++
      "sleep 0.1 && " ++
      "xdotool getactivewindow windowmove " ++
      "$(xdotool getmouselocation --shell | grep X= | cut -d'=' -f2) " ++
      "$(echo $(($(xdotool getmouselocation --shell | grep Y= | cut -d'=' -f2) - 200))); " ++
      "else " ++
      "sleep 0.1 && " ++
      "xdotool getactivewindow windowmove " ++
      "$(xdotool getmouselocation --shell | grep X= | cut -d'=' -f2) " ++
      "$(xdotool getmouselocation --shell | grep Y= | cut -d'=' -f2); " ++
      "fi"
    centerAndSizeTo840x440 = (W.RationalRect ((1 - (840 / 1920)) / 2) ((1 - (440 / 1080)) / 2) (840 / 1920) (440 / 1080))
