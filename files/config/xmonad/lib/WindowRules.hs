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
import XMonad.ManageHook (className, composeAll)
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
-- Window Rules
------------------------------------------------------------------------
myManageHook = composeAll
    [ className =? "discord"              --> doShift "2"          -- Move "discord" and "vesktop" to Workspace 2.
    , className =? "vesktop"              --> doShift "2"          -- ...
    , title =? "FLOAT_MP"                 --> doCenterFloat        -- Float and Center Windows where Title equals "FLOAT_MP".
    , title =? "Volume Control"           --> doFloat              -- Float Volume Control Windows.
    , title =? "Lautstärkeregler"         --> doFloat              -- ...
    , isDialog                            --> doCenterFloat        -- Float and Center Dialog Windows.
    , title =? "emote"                    --> (doFocus <+> doWarp) -- Focus and Warp Mouse to "emote" Window.
    , className =? "emote"                --> (doFocus <+> doWarp) -- ...
    , title =? "vicinae"                  --> (doFocus <+> doWarp) -- Focus and Warp Mouse to "vicinae" Window.
    , className =? "vicinae"              --> (doFocus <+> doWarp) -- ...
    , title =? "FLOAT_ME_NOW"             --> doRectFloat (W.RationalRect 0.15 0.1 0.7 0.8) -- Float and Move "FLOAT_ME_NOW" Windows.
    , title =? "Library"                  --> doCenterFloat        -- Center Float Browser Library.
    , className =? "Steam"                --> doShift "2"          -- Move "Steam" to Workspace 2.
    , title =? "Steam"                    --> doShift "2"          -- ...
    , className =? "weston"               --> doFullFloat          -- Float and Fullscreen Weston Window.
    , className =? "weston-1"             --> doFullFloat          -- ...
    , className =? "Weston Compositor"    --> doFullFloat          -- ...
    , className =? "eww"                  --> doIgnore <+> doLower -- Move EWW Windows below all other Windows.
    , className =? "Eww"                  --> doIgnore <+> doLower -- ...
    , className =? "equibop"              --> doShift "2"          -- Move "equibop" to Workspace 2.
    , className =? "Ark"                  --> doFloat              -- Float Ark Archiver Window.
    , isDialog                            --> doF id               -- Stop Dialogues from Stealing Focus.
    , isDialog                            --> doF W.shiftMaster    -- Stop Dialogues from Reshuffling Tab Stack Order.
    , title =? "Media viewer"             --> doFloat              -- Float Telegram Media Viewer Window.
    , className =? "floorp"               --> doShift "2"          -- Send Floorp Browser to Workspace 2.
    , title =? "osu!"                     --> doShift "osu!"       -- Move osu!stable to the "osu!" Workspace.
    -- , (liftX $ withWindowSet (return . (== "9") . W.currentTag)) --> doFloat <+> doSink
    ]
