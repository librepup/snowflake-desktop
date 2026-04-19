------------------------------------------------------------------------
-- Keybinds
------------------------------------------------------------------------
module Keybinds where
import Definitions

------------------------------------------------------------------------
-- Imports
------------------------------------------------------------------------
-- Basics
import XMonad
import XMonad.Operations
import Data.Monoid
import Data.List (intercalate)
import Data.Char (isSpace)
import Data.Tree
import System.Exit
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import Control.Monad
import Control.Monad (when)
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
import XMonad.Hooks.ManageHelpers (isInProperty)
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory
import XMonad.Hooks.FadeWindows
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
import Graphics.X11.Xlib
import Graphics.X11.Xlib (xC_left_ptr)
import Graphics.X11.Xlib (warpPointer)
import Graphics.X11.Xlib.Extras
import Graphics.X11.Xlib.Extras (none, getWindowAttributes, wa_width, wa_height)
-- Prompt
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.Layout
import XMonad.Prompt.ConfirmPrompt

------------------------------------------------------------------------
-- Key Binds
------------------------------------------------------------------------
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    -- Terminals
    [ ((modm .|. shiftMask, xK_Return), spawn Definitions.myTerminal)
    --  ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    , ((modm, xK_Return), spawn Definitions.myTerminalFb)
    -- Run Prompt
    , ((modm, xK_t), shellPrompt myXPConfig)
    -- Kill Window
    , ((modm .|. shiftMask, xK_q), kill)
    , ((modm .|. shiftMask .|. controlMask, xK_q), spawn "xkill")
    -- Cycle Layouts
    -- , ((modm, xK_space), sendMessage NextLayout)
    , ((modm, xK_space), do
        screenRect <- fmap (screenRect . W.screenDetail . W.current) (gets windowset)
        let sw = fromIntegral $ rect_width screenRect
            sh = fromIntegral $ rect_height screenRect
            cx = (sw `div` 2) - (TS.ts_node_width myTSConfig `div` 2)
            cy = (sh `div` 2) - 200
            dynamicConfig = myTSConfig { TS.ts_originX = fromIntegral cx
                                       , TS.ts_originY = fromIntegral cy }
        TS.treeselectAction dynamicConfig layoutTree)
    , ((modm .|. controlMask, xK_space), setLayout $ XMonad.layoutHook conf)
    -- Scratchpads
    -- Focus Windows
    , ((modm, xK_Left), windows W.focusUp)
    , ((modm, xK_Right), windows W.focusDown)
    , ((modm, xK_Up), windows W.focusUp)
    , ((modm, xK_Down), windows W.focusDown)
    -- Tab Submap
    , ((modm, xK_Tab), submapDefault toggleWS $ M.fromList [
          ((0, xK_Right), moveTo Next (Not emptyWS))
        , ((0, xK_Left), moveTo Prev (Not emptyWS))
        , ((0, xK_t), spawn $ "dmenu_run" ++ dmenuArgs moriDmenuTheme ++ " -p '%:'")
        , ((0, xK_Tab), toggleWS)
        , ((0, xK_n), spawn "gnome-text-editor")
	, ((0, xK_a), spawn "pavucontrol")
        , ((0, xK_m), spawn "cp /etc/nixos/files/config/tauon/tauon.conf $HOME/.local/share/TauonMusicBox/tauon.conf && tauon")
        , ((controlMask, xK_n), spawn "nixmacs -Q --eval \"(load-theme 'modus-vivendi)\"")
        , ((0, xK_minus), sendMessage zoomOut)
        , ((0, xK_equal), sendMessage zoomIn)
        , ((0, xK_c), spawn "xcolor | xclip -selection clipboard")
        , ((0, xK_r), sendMessage zoomReset)
        , ((0, xK_e), spawn "nixmacs-client -c")
        , ((0, xK_k), spawn "if pgrep picom > /dev/null 2>&1; then pkill picom; else picom & fi")
        , ((0, xK_space), setLayout $ XMonad.layoutHook conf)
        , ((0, xK_Return), spawn Definitions.myTerminal)
        , ((shiftMask, xK_Return), spawn Definitions.myTerminalFb)
        , ((controlMask, xK_Return), spawn "arcan_db add_appl_kv console font_size 14 >/dev/null 2>&1 && arcan console lash")
        , ((shiftMask, xK_backslash), spawn "kitty -o font_family='DejaVu Sans Mono' -o font_size=14 -o modify_font='cell_width 110%' xonsh")
        , ((shiftMask .|. controlMask, xK_Return), spawn "term rc")
        , ((shiftMask .|. controlMask, xK_t), namedScratchpadAction myScratchpads "terminal")
        , ((shiftMask .|. controlMask, xK_n), namedScratchpadAction myScratchpads "notes")
        , ((shiftMask .|. controlMask, xK_d), namedScratchpadAction myScratchpads "scratchmsg")
        ])
    -- Move Windows
    , ((modm .|. shiftMask, xK_Left ), windows W.swapUp)
    , ((modm .|. shiftMask, xK_Right), windows W.swapDown)
    , ((modm .|. shiftMask, xK_Up   ), sendMessage Expand)
    , ((modm .|. shiftMask, xK_Down ), sendMessage Shrink)
    -- Shrink or Expand Master Area
    , ((modm, xK_h), sendMessage Shrink)
    , ((modm, xK_v), sendMessage Expand)
    -- Resize Windows
    , ((modm .|. controlMask, xK_Left), sendMessage Shrink)
    , ((modm .|. controlMask, xK_Right), sendMessage Expand)
    , ((modm .|. controlMask, xK_Up), sendMessage MirrorExpand)
    , ((modm .|. controlMask, xK_Down), sendMessage MirrorShrink)
    -- Increment or Decrement Windows in Master Stack
    , ((modm, xK_comma), sendMessage (IncMasterN 1))
    , ((modm, xK_period), sendMessage (IncMasterN (-1)))
    -- Toggle Picom
    , ((myWinMask .|. shiftMask .|. controlMask, xK_p), spawn "if pgrep picom > /dev/null 2>&1; then notify-send 'Picom' 'Killing Picom...' && pkill -9 picom; else notify-send 'Picom' 'Starting Picom...' && picom & fi")
    -- Toggle Floating
    , ((modm .|. shiftMask, xK_space), withFocused toggleFloat)
    -- Toggle Fullscreen
    , ((modm .|. shiftMask, xK_t), sendMessage ToggleStruts >> sendMessage (Toggle NBFULL))
    -- Switch Layouts
    , ((modm, xK_y), sendMessage NextLayout)
    -- Applications
    , ((modm .|. shiftMask, xK_f), spawn "nixmacs")
    , ((myWinMask .|. shiftMask, xK_f), spawn "acme")
    , ((modm, xK_s), spawn "zen")
    , ((modm .|. shiftMask, xK_s), spawn "firefox")
    , ((modm .|. controlMask, xK_s), spawn "floorp")
    , ((modm, xK_a), spawn "flameshot gui")
    , ((modm, xK_d), spawn "icedove")
    -- Exit XMonad
    , ((modm .|. shiftMask, xK_e), confirmPrompt myXPConfig "Type 'yes' to exit:" $ io (exitWith ExitSuccess))
    , ((myWinMask .|. shiftMask, xK_x), io (exitWith ExitSuccess))
    -- Restart XMonad
    , ((modm .|. shiftMask, xK_p), spawn $
        "if command -v notify-send > /dev/null; then " ++
          "notify-send 'XMonad' 'Recompiling...' -i $HOME/Pictures/Icons/xmonad_logo.png; " ++
        "fi; " ++
        "xmonad --recompile; " ++
        "xmonad --restart; " ++
        "if command -v notify-send > /dev/null; then " ++
          "notify-send 'XMonad' 'Restarted Successfully!' -i $HOME/Pictures/Icons/xmonad_logo.png; " ++
        "fi;")
    -- Reload XMonad
    , ((modm .|. shiftMask, xK_c), spawn $
        "if command -v notify-send > /dev/null; then " ++
          "notify-send 'XMonad' 'Recompiling...' -i $HOME/Pictures/Icons/xmonad_logo.png; " ++
        "fi; " ++
        "xmonad --recompile; " ++
        "xmonad --restart; " ++
        "if command -v notify-send > /dev/null; then " ++
          "notify-send 'XMonad' 'Restarted Successfully!' -i $HOME/Pictures/Icons/xmonad_logo.png; " ++
        "fi;")
    -- Sub-Layout Tabbing
    , ((myWinMask .|. controlMask, xK_Left), sendMessage $ pullGroup L)
    , ((myWinMask .|. controlMask, xK_Right), sendMessage $ pullGroup R)
    , ((myWinMask .|. controlMask, xK_Up), sendMessage $ pullGroup U)
    , ((myWinMask .|. controlMask, xK_Down), sendMessage $ pullGroup D)
    , ((myWinMask .|. controlMask, xK_u), withFocused (sendMessage . UnMerge))
    , ((myWinMask .|. controlMask .|. shiftMask, xK_u), withFocused (sendMessage . UnMergeAll))
    , ((myWinMask .|. controlMask, xK_Tab), onGroup W.focusDown')
    -- Minimize
    , ((myWinMask, xK_i), withFocused minimizeWindow)
    , ((myWinMask .|. shiftMask, xK_i), withLastMinimized maximizeWindowAndFocus)
    -- Tree Select
    , ((modm, xK_p), do
        screenRect <- fmap (screenRect . W.screenDetail . W.current) (gets windowset)
        let sw = fromIntegral $ rect_width screenRect
            sh = fromIntegral $ rect_height screenRect
            cx = (sw `div` 2) - (TS.ts_node_width myTSConfig `div` 2)
            cy = (sh `div` 2) - 200
            dynamicConfig = myTSConfig { TS.ts_originX = fromIntegral cx
                                       , TS.ts_originY = fromIntegral cy }
        TS.treeselectAction dynamicConfig myTree)
    ]
    ++
    -- WinMod (Super key) Bindings
    [ ((myWinMask, xK_l), spawn $
        "if command -v betterlockscreen > /dev/null; then " ++
          "betterlockscreen --lock; " ++
        "elif command -v i3lock > /dev/null; then " ++
          "i3lock -i $HOME/Pictures/Wallpapers/dangeroooous_jungle_wp.png --ignore-empty-password; " ++
        "else " ++
          "if command -v notify-send > /dev/null; then " ++
            "notify-send 'Error' 'No Lockscreen Found' -i $HOME/Pictures/Icons/error.png; " ++
          "fi; " ++
        "fi")
    , ((myWinMask, xK_e), spawn $
        "if command -v thunar > /dev/null; then " ++
          "thunar; " ++
        "elif command -v nautilus > /dev/null; then " ++
          "nautilus; " ++
        "elif command -v konqueror > /dev/null; then " ++
          "konqueror; " ++
        "else " ++
          "if command -v notify-send > /dev/null; then " ++
            "notify-send 'Error' 'No Explorer Application Found' -i $HOME/Pictures/Icons/error.png; " ++
          "fi; " ++
        "fi")
    , ((myWinMask .|. shiftMask, xK_e), spawn "thunar -q")
    , ((myWinMask, xK_t), spawn "vicinae open")
    , ((myWinMask .|. shiftMask, xK_t), spawn "compgen -c | sort -u | vicinae dmenu --placeholder '%:' | sh")
    , ((myWinMask, xK_period), spawn "emote")
    , ((myWinMask, xK_v), spawn $
      "if command -v pactl > /dev/null && command -v dmenu > /dev/null; then " ++
        "chosen=$(seq 0 5 150 | awk '{print $1 \"%\"}' | dmenu -nb '#0A0A05' -nf '#D4921A' -sf '#4CBF5A' -sb '#C23FAD' -fn 'TempleOS:size=14' -p '%:'); " ++
        "[ -n \"$chosen\" ] && pactl set-sink-volume @DEFAULT_SINK@ \"$chosen\"; " ++
      "elif command -v pavucontrol > /dev/null; then " ++
        "pavucontrol; " ++
      "else " ++
        "if command -v notify-send > /dev/null; then " ++
          "notify-send 'Error' 'No Volume Application Found' -i $HOME/Pictures/Icons/error.png; " ++
        "fi; " ++
      "fi")
    , ((myWinMask, xK_w), spawn $
        "if command -v xclip > /dev/null; then " ++
          "xclip -o selection primary | xclip -selection clipboard; " ++
        "fi")
    , ((myWinMask, xK_y), spawn $
        "if command -v xdotool > /dev/null && command -v xclip > /dev/null; then " ++
          "xdotool keyup Super_L Super_R; " ++
          "sleep 0.1; " ++
          "xclip -o -selection clipboard; " ++
          "xdotool key --clearmodifiers shift+Insert; " ++
        "fi")
    -- Move Cursor
    , ((myWinMask, xK_Left), warpToScreen 0 0.5 0.5)
    , ((myWinMask, xK_Right), warpToScreen 1 0.5 0.5)
    , ((myWinMask .|. shiftMask, xK_Right), screenBy 1 >>= moveAndFollow)
    , ((myWinMask .|. shiftMask, xK_Left), screenBy (-1) >>= moveAndFollow)
    -- Resize
    , ((myWinMask, xK_Up), sendMessage MirrorExpand)
    , ((myWinMask, xK_Down), sendMessage MirrorShrink)
    -- Screensaver controls
    , ((myWinMask, xK_1), spawn "xset s off -dpms s noblank && notify-send 'Screensaver' 'Turned OFF.' -i $HOME/Pictures/Icons/no.png")
    , ((myWinMask, xK_2), spawn "xset s on +dpms s blank && notify-send 'Screensaver' 'Turned ON.' -i $HOME/Pictures/Icons/yes.png")
    -- Extra Workspaces
    , ((modm, xK_grave), windows (W.view "osu!"))
    , ((modm .|. shiftMask, xK_grave), windows (W.shift "osu!"))
    , ((modm, xK_minus), windows (W.view "Minus"))
    , ((modm .|. shiftMask, xK_minus), windows (W.shift "Minus"))
    , ((modm, xK_equal), windows (W.view "Plus"))
    , ((modm .|. shiftMask, xK_equal), windows (W.shift "Plus"))
    , ((modm, xK_F1), windows (W.view "F1"))
    , ((modm .|. shiftMask, xK_F1), windows (W.shift "F1"))
    , ((modm, xK_F2), windows (W.view "F2"))
    , ((modm .|. shiftMask, xK_F2), windows (W.shift "F2"))
    , ((modm, xK_F3), windows (W.view "F3"))
    , ((modm .|. shiftMask, xK_F3), windows (W.shift "F3"))
    , ((modm, xK_F4), windows (W.view "F4"))
    , ((modm .|. shiftMask, xK_F4), windows (W.shift "F4"))
    , ((modm, xK_F5), windows (W.view "F5"))
    , ((modm .|. shiftMask, xK_F5), windows (W.shift "F5"))
    , ((modm, xK_F6), windows (W.view "F6"))
    , ((modm .|. shiftMask, xK_F6), windows (W.shift "F6"))
    , ((modm, xK_F7), windows (W.view "F7"))
    , ((modm .|. shiftMask, xK_F7), windows (W.shift "F7"))
    , ((modm, xK_F8), windows (W.view "F8"))
    , ((modm .|. shiftMask, xK_F8), windows (W.shift "F8"))
    , ((modm, xK_F9), windows (W.view "F9"))
    , ((modm .|. shiftMask, xK_F9), windows (W.shift "F9"))
    , ((modm, xK_F10), windows (W.view "F10"))
    , ((modm .|. shiftMask, xK_F10), windows (W.shift "F10"))
    , ((modm, xK_F11), windows (W.view "F11"))
    , ((modm .|. shiftMask, xK_F11), windows (W.shift "F11"))
    , ((modm, xK_F12), windows (W.view "F12"))
    , ((modm .|. shiftMask, xK_F12), windows (W.shift "F12"))
    , ((modm, xK_Home), windows (W.view "\xEF85"))
    , ((modm .|. shiftMask, xK_Home), windows (W.shift "\xEF85"))
    ]
    ++
    -- Switch Workspaces
    -- Mod-[1..9] - Switch to Workspace N | Mod-Shift-[1..9] - Move Window to Workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Mouse Binds
------------------------------------------------------------------------
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    ]
