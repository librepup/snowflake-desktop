------------------------------------------------------------------------
-- AutoStart
------------------------------------------------------------------------
module AutoStart where
import Definitions
import Keybinds
import Layouts

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
-- import XMonad.Actions.CycleWS
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
-- Autostart
------------------------------------------------------------------------
myAutostart :: X ()
myAutostart = do
  spawnOnceIfExists "xrdb" "xrdb ~/.Xresources" -- XResources
  spawnIfExists "xsetroot" "xsetroot -cursor_name left_ptr" -- Cursor
  spawnOnceIfExists "xrandr" "xrandr --output DP-0 --primary --mode 1920x1080 --rate 144.00 --output HDMI-0 --mode 1920x1080 --right-of DP-0" -- Monitor
  spawnOnceIfExists "xinput" "xinput set-prop 'Mad Catz Global' 'libinput Accel Profile Enabled' 0 1 0 && xinput set-prop 'Mad Catz Global' 'libinput Accel Speed' 0.3" -- Mouse (1)
  spawnOnceIfExists "xinput" "xinput set-prop 'Mad Catz Global MADCATZ R.A.T. 8+ gaming mouse' 'libinput Accel Profile Enabled' 0 1 0 && xinput set-prop 'Mad Catz Global MADCATZ R.A.T. 8+ gaming mouse' 'libinput Accel Speed' 0.3" -- Mouse (2)
  spawnIfExists "xmodmap" "setxkbmap us -variant colemak && xmodmap ~/.my-input-remappings/xmodmap/global" -- XModMap
  spawnIfExists "xbindkeys" "sleep 1 && killall xbindkeys && xbindkeys --file ~/.my-input-remappings/xbindkeys/global" -- XBindKeys
  spawnOnceIfExists "dex" "dex --autostart --environment xmonad" -- XMonad Environment
  spawnOnceIfExists "xss-lock" "xss-lock --transfer-sleep-lock -- betterlockscreen --lock blur --span --time-format %H:%M:%S --show-layout &" -- BetterLockscreen XSS Lock
  spawnOnceIfExists "nm-applet" "if ! pgrep nm-applet > /dev/null 2>&1; then nm-applet & fi" -- NetworkManager Applet
  spawnOnceIfExists "picom" "if ! pgrep picom > /dev/null 2>&1; then picom & fi" -- Picom
  spawnOnceIfExists "jonabar-mori" "if ! pgrep polybar > /dev/null; then jonabar-mori & fi" -- Polybar
  spawnOnceIfExists "emote" "if ! pgrep emote > /dev/null 2>&1; then emote & fi" -- Emote
  spawnOnceIfExists "feh" "sleep 1 && feh --bg-fill $HOME/Pictures/Wallpapers/Mori\\ Calliope/06.png" -- Wallpaper
  spawnOnceIfExists "nixmacs-client" "if ! nixmacs-client -e \"(emacs-pid)\" > /dev/null 2>&1; then nixmacs --fg-daemon & fi" -- NixMacs Daemon
  spawnOnceIfExists "xset" "xset s off -dpms s noblank" -- Disable Screensaver
  spawnOnceIfExists "redshift" "if ! pgrep redshift > /dev/null 2>&1; then redshift -x && redshift -l 52.520008:13.404954 -t 5200:5200 & fi" -- Bluelight Filter
  spawnOnceIfExists "dunst" "if ! pgrep dunst > /dev/null 2>&1; then dunst & fi" -- Dunst
  spawnOnceIfExists "keepassxc" "if ! pgrep keepassxc > /dev/null 2>&1; then keepassxc & fi" -- KeePassXC
  spawnOnceIfExists "yad" "pkill yad && $HOME/.trayicon-scripts/wayPaper.sh &"

------------------------------------------------------------------------
-- Startup Hook
------------------------------------------------------------------------
myStartupHook :: X ()
myStartupHook = do
    flashText def 1 " " -- Initialize ShowText
    setDefaultCursor xC_left_ptr -- Set Cursor
    myAutostart -- Autostart Hook
    setWMName "LG3D" -- Set WM Name for Java Apps
