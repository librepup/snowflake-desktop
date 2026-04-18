------------------------------------------------------------------------
-- Layouts
------------------------------------------------------------------------
module Layouts where
import Definitions
import Keybinds

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
import XMonad.Layout.SimpleFloat (simpleFloat, simpleFloat')
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.Minimize
import XMonad.Layout.TwoPane
import XMonad.Layout.Grid
import XMonad.Layout.CircleEx
import XMonad.Layout.ZoomRow
import XMonad.Layout.LimitWindows
import XMonad.Layout.Decoration (shrinkText)
import XMonad.Layout.NoFrillsDecoration
import XMonad.Layout.WindowArranger
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
-- Layouts
------------------------------------------------------------------------
myLayoutHook = avoidStruts
             $ onWorkspace "9" allFloat
             $ onWorkspace "osu!" fullLayout
             $ smartBorders
             $ mkToggle (NBFULL ?? EOT)
             $ tabbedLayout
             ||| multiLayout
             ||| spiralLayout
             ||| accordionLayout
             ||| circleLayout
             ||| fullLayout
  where
    spacingWithEdge i = spacingRaw True (Border i i i i) True (Border i i i i) True
    -- Tabbed
    tabbedLayout =
      named "Tabbed"
      $ minimize
      $ (tabbed shrinkText myTabTheme)
    -- Multi
    multiLayout =
      named "Multi"
      $ minimize
      $ windowNavigation
      $ addTabs shrinkText myTabTheme
      $ subLayout [] Simplest
      $ BW.boringWindows
      $ spacingWithEdge 4
      $ ResizableTall 1 (3/100) (1/2) []
    -- Spiral
    spiralLayout =
      named "Spiral"
      $ minimize
      $ spacingWithEdge 4
      $ spiral (6/7)
    -- Accordion
    accordionLayout =
      named "Accordion"
      $ minimize
      $ spacingWithEdge 4
      Accordion
    -- Circle
    circleLayout =
      named "Circle"
      $ minimize
      $ spacingWithEdge 4
      circle
    -- Fullscreen
    fullLayout =
      named "Full"
      $ minimize
      $ noBorders Full
    -- Floating
    allFloat =
      named "Floating"
      $ minimize
      $ simpleFloat' shrinkText moriTabTheme
