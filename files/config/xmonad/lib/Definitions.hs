------------------------------------------------------------------------
-- Definitions
------------------------------------------------------------------------
module Definitions where

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
import XMonad.Prompt.ConfirmPrompt

------------------------------------------------------------------------
-- Definitions
------------------------------------------------------------------------
-- Modify Opacity
myFadeHook :: FadeHook
myFadeHook = composeAll [ className =? "Emacs" --> opacity 0.80
                        , className =? "anvil" --> opacity 0.80
                        ]

-- Spawn If Exists Helper
spawnIfExists :: String -> String -> X ()
spawnIfExists basecmd cmd =
  spawn $ "command -v " ++ basecmd ++ " >/dev/null 2>&1 && " ++ cmd

spawnOnceIfExists :: String -> String -> X ()
spawnOnceIfExists basecmd cmd =
  spawnOnce $ "command -v " ++ basecmd ++ " >/dev/null 2>&1 && " ++ cmd
-- Define Alt States
data AltState = AltEnabled | AltDisabled
  deriving (Eq, Show, Read)

instance ExtensionClass AltState where
  initialValue = AltEnabled

-- Move and Follow to Screen
moveAndFollow :: ScreenId -> X ()
moveAndFollow sc = do
  screenWorkspace sc >>= flip whenJust (\w ->
    windows (W.view w . W.shift w))
  warpToScreen sc 0.5 0.5
-- Trim Helper
trimWS :: String -> String
trimWS = reverse . dropWhile isSpace . reverse . dropWhile isSpace
-- Toggle Float
toggleFloat w = windows (\s -> if M.member w (W.floating s)
                          then
                            W.sink w s
                          else
                            (W.float w (W.RationalRect 0.15 0.15 0.7 0.7) s))
-- Warp to Window
doWarp :: ManageHook
doWarp = ask >>= \w -> liftX $ do
  dpy <- asks display
  wa <- io $ getWindowAttributes dpy w
  let cx = fromIntegral (wa_width wa) `div` 2
      cy = fromIntegral (wa_height wa) `div` 2
  io $ warpPointer dpy none w 0 0 0 0 cx cy
  return mempty
-- Titlebar Theme
jungleDecoTheme = def
    { activeColor       = "#ffbf2d"
    , activeBorderColor = "#ffbf2d"
    , activeTextColor   = "#000000"
    , inactiveColor     = "#1d1f21"
    , inactiveBorderColor = "#1d1f21"
    , inactiveTextColor = "#888888"
    , decoHeight        = 10
    , fontName          = "xft:TempleOS:size=8"
    }
moriDecoTheme = def
    { activeColor       = "#ec3372"
    , activeBorderColor = "#ec3372"
    , activeTextColor   = "#000000"
    , inactiveColor     = "#1d1f21"
    , inactiveBorderColor = "#1d1f21"
    , inactiveTextColor = "#888888"
    , decoHeight        = 10
    , fontName          = "xft:DejaVu Sans Mono:size=10"
    }
-- Prompt/XP Theme(s)
marnieXPConfig = def
    { font              = "xft:DejaVu Sans Mono:size=10"
    , bgColor           = "#282A2E"
    , fgColor           = "#ffffff"
    , bgHLight          = "#ff2a54"
    , fgHLight          = "#000000"
    , borderColor       = "#ff2a54"
    , promptBorderWidth = 2
    , position          = Top
    , height            = 24
    , historySize       = 0
    }
jungleXPConfig = def
    { font              = "xft:TempleOS:size=8"
    , bgColor           = "#1d1f21"
    , fgColor           = "#ffffff"
    , bgHLight          = "#ffbf2d"
    , fgHLight          = "#1d1f21"
    , borderColor       = "#ffbf2d"
    , promptBorderWidth = 2
    , position          = Top
    , height            = 24
    , historySize       = 0
    }
moriXPConfig = def
    { font                = "xft:DejaVu Sans Mono:size=10"
    , bgColor             = "#1d1f21"
    , fgColor             = "#ffffff"
    , bgHLight            = "#ec3372"
    , fgHLight            = "#1d1f21"
    , borderColor         = "#ec3372"
    , promptBorderWidth   = 2
    , position            = Top
    , height              = 24
    , historySize         = 0
    }
-- Tab Theme(s)
marnieTabTheme = def
    { activeColor         = "#ff2a54"
    , inactiveColor       = "#282A2E"
    , activeBorderColor   = "#ff2a54"
    , inactiveBorderColor = "#282A2E"
    , urgentBorderColor   = "#ff0000"
    , activeTextColor     = "#000000"
    , inactiveTextColor   = "#888888"
    , urgentTextColor     = "#ffffff"
    , fontName            = "xft:DejaVu Sans Mono:size=10"
    , decoHeight          = 14
    }
jungleTabTheme = def
    { activeColor         = "#ffbf2d"
    , inactiveColor       = "#1d1f21"
    , urgentColor         = "#ff0000"
    , activeBorderColor   = "#ffbf2d"
    , inactiveBorderColor = "#1d1f21"
    , urgentBorderColor   = "#ff0000"
    , activeTextColor     = "#000000"
    , inactiveTextColor   = "#888888"
    , urgentTextColor     = "#ffffff"
    -- , fontName            = "xft:TempleOS:size=8"
    , fontName            = "xft:DejaVu Sans Mono:size=10"
    , decoHeight          = 14
    }
moriTabTheme = def
    { activeColor         = "#ec3372"
    , inactiveColor       = "#1d1f21"
    , urgentColor         = "#ff0000"
    , activeBorderColor   = "#ec3372"
    , inactiveBorderColor = "#1d1f21"
    , urgentBorderColor   = "#ff0000"
    , activeTextColor     = "#000000"
    , inactiveTextColor   = "#888888"
    , urgentTextColor     = "#ffffff"
    , fontName            = "xft:DejaVu Sans Mono:size=10"
    , decoHeight          = 14
    }
-- FlashText Theme(s)
jungleFlashTheme = def
    { st_font             = "xft:TempleOS:size=8"
    , st_bg               = "#1d1f21"
    , st_fg               = "#ffbf2d"
    }
marnieFlashTheme = def
    { st_font             = "xft:DejaVu Sans Mono:size=10"
    , st_bg               = "#1d1f21"
    , st_fg               = "#ff2a54"
    }
moriFlashTheme = def
    { st_font             = "xft:DejaVu Sans Mono:size=10"
    , st_bg               = "#1d1f21"
    , st_fg               = "#ec3372"
    }
-- Colorscheme(s)
data ColorScheme = ColorScheme
    { focused :: String
    , normal :: String
    }
marnieColorscheme = ColorScheme
    { focused = "#ff2a54"
    , normal  = "#1d1f21"
    }
jungleColorscheme = ColorScheme
    { focused = "#ffbf2d"
    , normal  = "#1d1f21"
    }
moriColorscheme = ColorScheme
    { focused = "#ec3372"
    , normal  = "#1d1f21"
    }
-- Dmenu Theme(s)
data DmenuTheme = DmenuTheme
    { normalBackground :: String
    , normalForeground :: String
    , selectedBackground :: String
    , selectedForeground :: String
    , selectedFont :: String
    }
marnieDmenuTheme = DmenuTheme
    { normalBackground   = "#282A2E"
    , normalForeground   = "#c13f47"
    , selectedBackground = "#c13f47"
    , selectedForeground = "#272A2E"
    , selectedFont       = "DejaVu Sans Mono:size=18"
    }
jungleDmenuTheme = DmenuTheme
    { normalBackground   = "#0A0A05"
    , normalForeground   = "#D4921A"
    , selectedBackground = "#C23FAD"
    , selectedForeground = "#4CBF5A"
    , selectedFont       = "TempleOS:size=14"
    }
gigiDmenuTheme = DmenuTheme
    { normalBackground   = "#0A0A05"
    , normalForeground   = "#D4921A"
    , selectedBackground = "#D4921A"
    , selectedForeground = "#000000"
    , selectedFont       = "DejaVu Sans Mono:size=18"
    }
moriDmenuTheme = DmenuTheme
    { normalBackground   = "#0A0A05"
    , normalForeground   = "#ec3372"
    , selectedBackground = "#ec3372"
    , selectedForeground = "#000000"
    , selectedFont       = "DejaVu Sans Mono:size=18"
    }
dmenuArgs :: DmenuTheme -> String
dmenuArgs t = " -nb '" ++ normalBackground t ++
            "' -nf '" ++ normalForeground t ++
            "' -sb '" ++ selectedBackground t ++
            "' -sf '" ++ selectedForeground t ++
            "' -fn '" ++ selectedFont t ++ "'"

------------------------------------------------------------------------
-- Tree Select
------------------------------------------------------------------------
myTSConfig :: TS.TSConfig (X ())
myTSConfig = TS.TSConfig
  { TS.ts_hidechildren = False
  , TS.ts_background   = 0x90000000
  , TS.ts_font         = "xft:DejaVu Sans Mono:size=16"
  , TS.ts_node         = (0xffffffff, 0xff1d1f21)
  , TS.ts_nodealt      = (0xffcccccc, 0xff1d1f21)
  , TS.ts_highlight    = (0xff000000, 0xffec3372)
  , TS.ts_extra        = 0
  , TS.ts_node_height  = 30
  , TS.ts_node_width   = 250
  , TS.ts_originX      = 0
  , TS.ts_originY      = 0
  , TS.ts_indent       = 80
  , TS.ts_navigate = M.fromList
    [ ((0, xK_Escape), TS.cancel)
    , ((0, xK_Return), TS.select)
    , ((0, xK_space), TS.select)
    , ((0, xK_Up), TS.movePrev)
    , ((0, xK_Down), TS.moveNext)
    , ((0, xK_Left), TS.moveParent)
    , ((0, xK_Right), TS.moveChild)
    , ((0, xK_Tab), TS.moveChild)
    , ((0, xK_BackSpace), TS.moveParent)
    , ((shiftMask, xK_Tab), TS.moveParent)
    , ((0, xK_k), TS.movePrev)
    , ((0, xK_j), TS.moveNext)
    , ((0, xK_h), TS.moveParent)
    , ((0, xK_l), TS.moveChild)
    , ((0, xK_o), TS.moveHistBack)
    , ((0, xK_i), TS.moveHistForward)
    ]
  }

myTree :: [Tree (TS.TSNode (X ()))]
myTree =
  [ Node (TS.TSNode "Most Used" "" (return ()))
      [ Node (TS.TSNode "Discord (No GPU)" "" (spawn "discord --enable-features=UseOzonePlatform --ozone-platform=x11 --disable-gpu")) []
      , Node (TS.TSNode "Krita" "" (spawn "krita")) []
      , Node (TS.TSNode "Steam" "" (spawn "steam")) []
      , Node (TS.TSNode "osu!" "" (spawn "osu-stable")) []
      ]
  , Node (TS.TSNode "Internet" "" (return ()))
      [ Node (TS.TSNode "Zen" "" (spawn "zen")) []
      , Node (TS.TSNode "Firefox" "" (spawn "firefox")) []
      , Node (TS.TSNode "Floorp" "" (spawn "floorp")) []
      , Node (TS.TSNode "Edge" "" (spawn "microsoft-edge")) []
      , Node (TS.TSNode "Tor" "" (spawn "tor-browser")) []
      , Node (TS.TSNode "OperaGX" "" (spawn "flatpak run com.opera.opera-gx")) []
      , Node (TS.TSNode "FileZilla" "" (spawn "filezilla")) []
      ]
  , Node (TS.TSNode "Chat" "" (return ()))
      [ Node (TS.TSNode "Discord" "" (spawn "discord")) []
      , Node (TS.TSNode "Discord (No GPU)" "" (spawn "discord --enable-features=UseOzonePlatform --ozone-platform=x11 --disable-gpu")) []
      , Node (TS.TSNode "Equibop" "" (spawn "equibop")) []
      , Node (TS.TSNode "Signal" "" (spawn "signal-desktop")) []
      , Node (TS.TSNode "Telegram" "" (spawn "Telegram")) []
      , Node (TS.TSNode "Element" "" (spawn "element-desktop")) []
      ]
  , Node (TS.TSNode "Editing" "" (return ()))
      [ Node (TS.TSNode "Text" "" (return ()))
          [ Node (TS.TSNode "Emacs" "" (spawn "nixmacs")) []
          , Node (TS.TSNode "Notepad" "" (spawn "gnome-text-editor")) []
          ]
      , Node (TS.TSNode "Video" "" (return ()))
          [ Node (TS.TSNode "KDEnlive" "" (spawn "kdenlive")) []
          ]
      , Node (TS.TSNode "Images" "" (return ()))
          [ Node (TS.TSNode "Krita" "" (spawn "krita")) []
          , Node (TS.TSNode "GIMP" "" (spawn "gimp")) []
          ]
      ]
  , Node (TS.TSNode "Games" "" (return ()))
      [ Node (TS.TSNode "Steam" "" (spawn "steam")) []
      , Node (TS.TSNode "osu!" "" (spawn "osu-stable")) []
      , Node (TS.TSNode "osu!lazer" "" (spawn "osu!")) []
      , Node (TS.TSNode "NotITG" "" (spawn "notitg")) []
      , Node (TS.TSNode "OutFox" "" (spawn "OutFox")) []
      , Node (TS.TSNode "ITGMania" "" (spawn "itgmania")) []
      , Node (TS.TSNode "Etterna" "" (spawn "etterna")) []
      ]
  , Node (TS.TSNode "Tools" "" (return ()))
      [ Node (TS.TSNode "Explorer" "" (spawn "thunar -q && thunar")) []
      , Node (TS.TSNode "Text Extractor" "" (spawn "image-text-extractor'")) []
      , Node (TS.TSNode "Flameshot" "" (spawn "flameshot gui")) []
      ]
  , Node (TS.TSNode "Settings" "" (return ()))
      [ Node (TS.TSNode "Audio" "" (return ()))
        [ Node (TS.TSNode "Pavucontrol" "" (spawn "pavucontrol")) []
        , Node (TS.TSNode "QPWGraph" "" (spawn "qpwgraph")) []
        , Node (TS.TSNode "EasyEffects" "" (spawn "easyeffects")) []
        , Node (TS.TSNode "Helvum" "" (spawn "helvum")) []
        ]
      , Node (TS.TSNode "Video" "" (return ()))
        [ Node (TS.TSNode "Nvidia" "" (spawn "nvidia-settings")) []
        , Node (TS.TSNode "XRandr" "" (spawn "lxrandr")) []
        , Node (TS.TSNode "Picom" "" (spawn "if pgrep picom > /dev/null 2>&1; then pkill -9 picom; else picom & fi")) []
        ]
      , Node (TS.TSNode "XMonad" "" (return ()))
        [ Node (TS.TSNode "Recompile" "" (spawn $
                                          "notify-send -i $HOME/Pictures/Icons/xmonad_logo.png 'XMonad' 'Recompiling...'; " ++
                                          "xmonad --recompile; " ++
                                          "xmonad --restart; " ++
                                          "notify-send -i $HOME/Pictures/Icons/xmonad_logo.png 'XMonad' 'Successfully Recompiled!'")) []
        , Node (TS.TSNode "Restart" "" (spawn $
                                        "notify-send -i $HOME/Pictures/xmonad_logo.png 'XMonad' 'Restarting...'; " ++
                                        "xmonad --restart; " ++
                                        "notify-send -i $HOME/Pictures/Icons/xmonad_logo.png 'XMonad' 'Successfully Restarted!'")) []
        , Node (TS.TSNode "Edit Config" "" (spawn "nixmacs $HOME/.xmonad/xmonad.hs")) []
        ]
      ]
  ]

layoutTree :: [Tree (TS.TSNode (X ()))]
layoutTree =
  [ Node (TS.TSNode "Tabbed" "" (sendMessage $ JumpToLayout "Tabbed")) []
  , Node (TS.TSNode "Multi" "" (sendMessage $ JumpToLayout "Multi")) []
  , Node (TS.TSNode "Spiral" "" (sendMessage $ JumpToLayout "Spiral")) []
  , Node (TS.TSNode "Accordion" "" (sendMessage $ JumpToLayout "Accordion")) []
  , Node (TS.TSNode "Circle" "" (sendMessage $ JumpToLayout "Circle")) []
  , Node (TS.TSNode "Full" "" (sendMessage $ JumpToLayout "Full")) []
  , Node (TS.TSNode "Floating" "" (sendMessage $ JumpToLayout "Floating")) []
  ]

------------------------------------------------------------------------
-- Scratchpads
------------------------------------------------------------------------
myScratchpads :: [NamedScratchpad]
myScratchpads =
  [ NS "terminal"
      "kitty --class scratchpad"
      (className =? "scratchpad")
      (customFloating $ W.RationalRect 0.1 0.1 0.8 0.8)
  , NS "notes"
      "kitty --class notes -e nixmacs -nw /tmp/Notes.md"
      (className =? "notes")
      (customFloating $ W.RationalRect 0.15 0.15 0.7 0.7)
  , NS "scratchmsg"
      "firefox --class scratchmsg --new-window https://discord.com/app"
      (className =? "scratchmsg")
      (customFloating $ W.RationalRect 0.15 0.15 0.7 0.7)
  ]

------------------------------------------------------------------------
-- Themes
------------------------------------------------------------------------
-- General
(myFocusedBorderColor, myNormalBorderColor) = (focused c, normal c)
  where c = moriColorscheme
-- FlashText
myFlashTheme = moriFlashTheme
-- Tabs
myTabTheme = moriTabTheme
-- Prompts
myXPConfig :: XPConfig
myXPConfig = moriXPConfig
-- Settings
functionWorkspaces = ["F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"]
namedWorkspaces = ["osu!","Minus","Plus","\xEF85"]
myWorkspaces    = ["1","2","3","4","5","6","7","8","9","10"] ++ functionWorkspaces ++ namedWorkspaces
myModMask       = mod1Mask  -- Alt Key (mod1)
myWinMask       = mod4Mask  -- Windows/Super Key (mod4)
myTerminalFb    = "kitty"   -- Terminal Emulator
myTerminal      = "kitty -o font_family='DejaVu Sans Mono' -o font_size=14 -o modify_font='cell_width 110%'" -- Fallback Terminal
myBorderWidth :: Dimension
myBorderWidth   = 2 -- Border Width
