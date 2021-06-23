import XMonad hiding ( (|||) )
import qualified XMonad.StackSet as W

import XMonad.Actions.CycleWS
import XMonad.Actions.GroupNavigation
import XMonad.Actions.MouseGestures
import XMonad.Actions.Navigation2D
import XMonad.Actions.Search
import XMonad.Actions.Submap
import XMonad.Actions.UpdatePointer
import XMonad.Actions.WindowGo

import XMonad.Hooks.InsertPosition

import qualified XMonad.Layout.Magnifier as Mag
import XMonad.Layout.BorderResize
import XMonad.Layout.Dishes
import XMonad.Layout.Fullscreen
import XMonad.Layout.Gaps
import XMonad.Layout.Grid
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.MouseResizableTile
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.Spiral
import XMonad.Layout.ToggleLayouts

import XMonad.Util.EZConfig
import XMonad.Util.NamedScratchpad
import XMonad.Util.Paste
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.XSelection

import XMonad.Prompt
import XMonad.Prompt.Man
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Shell

import qualified Data.Map as M
import System.Exit

myLayoutHook = lessBorders OtherIndicated $
               (toggleFull $ Mag.magnifierOff $ GridRatio $ 4/3) |||
               (toggleFull $ Mag.maximizeVertical $ Dishes 2 $ 1/6) |||
               (toggleFull $ Mag.magnifier' $ spiral $ 4/3)
  where gapped = gaps [(U,7), (D,7), (R,10), (L,10)]
        spaced = spacing 5 . gapped
        toggleFull layout = toggleLayouts Full $ spaced layout

modm = mod1Mask

browser = "vivaldi-stable"
myTerminal = "kitty"

scratchpads = [
    NS "ruby" (myTerminal ++ " -T ruby irb") (title =? "ruby") (customFloating $ W.RationalRect (1/3) (1/4) (1/3) (2/4)),
    NS "wiki" (myTerminal ++ " -T wiki vim ~/vimwiki/index.wiki") (title =? "wiki") (customFloating $ W.RationalRect (1/3) (1/6) (1/3) (4/6))
  ]

myWorkspaces = ["1","2","3","4","5","6","7","8","9"]

myXPConfig = def
  {
    searchPredicate = fuzzyMatch,
    sorter          = fuzzySort
  }

browserOpen url = safeSpawn browser [url]

myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    [
      --Spawn keys
      ((modm, xK_space), spawn "rofi -show combi"),
      ((modm .|. shiftMask, xK_b), spawn browser),
      ((modm, xK_b), runOrRaiseNext browser (resource =? browser)),
      ((modm .|. shiftMask, xK_Return), spawn myTerminal),
      ((modm, xK_Return), runOrRaiseNext myTerminal (className =? myTerminal)),

      --Workspace cycling
      --((modm, xK_Left), prevWS),
      --((modm, xK_Right), nextWS),
      ((modm, xK_Left), moveTo Prev NonEmptyWS),
      ((modm, xK_Right), moveTo Next NonEmptyWS),
      ((modm .|. shiftMask, xK_Left), shiftToNext >> prevWS),
      ((modm .|. shiftMask, xK_Right), shiftToPrev >> nextWS),
      ((modm .|. shiftMask, xK_Tab), toggleWS),

      --Vim navigation keys
      ((modm, xK_h), windowGo L True),
      ((modm, xK_j), windowGo D True),
      ((modm, xK_k), windowGo U True),
      ((modm, xK_l), windowGo R True),
      ((modm, xK_u), windows W.focusUp),
      ((modm, xK_d), windows W.focusDown),
      ((modm, xK_p), screenGo L True),
      ((modm, xK_n), screenGo R True),
      ((modm .|. shiftMask, xK_h), windowSwap L True),
      ((modm .|. shiftMask, xK_j), windowSwap D True),
      ((modm .|. shiftMask, xK_k), windowSwap U True),
      ((modm .|. shiftMask, xK_l), windowSwap R True),
      ((modm .|. shiftMask, xK_u), windows W.swapUp),
      ((modm .|. shiftMask, xK_d), windows W.swapDown),
      ((modm .|. shiftMask, xK_m), windows W.shiftMaster),
      ((modm .|. shiftMask, xK_p), do
        windowToScreen L True
        windowGo L True),
      ((modm .|. shiftMask, xK_n), do
        windowToScreen R True
        windowGo R True),

      --Toggle back and forth between two recent windows
      ((modm, xK_Tab), nextMatch History (return True)),

      --Resize master
      --((modm .|. shiftMask, xK_equal), sendMessage Mag.MagnifyMore),
      --((modm, xK_minus), sendMessage Mag.MagnifyLess),
      ((modm, xK_z), sendMessage Mag.Toggle),
      ((modm .|. shiftMask, xK_equal), sendMessage Expand),
      ((modm, xK_minus), sendMessage Shrink),
      ((modm .|. shiftMask, xK_z), sendMessage ToggleLayout),

      --Cycle layouts
      ((0, xK_Super_L), sendMessage NextLayout),
      ((0, xK_Super_R), setLayout $ XMonad.layoutHook conf),
      --((modm .|. controlMask, xK_space), sendMessage NextLayout),

      --XMonad keys
      ((modm, xK_x), spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi"),
      ((modm .|. shiftMask, xK_x), io (exitWith ExitSuccess)),
      ((modm .|. shiftMask, xK_q), kill),
      ((modm .|. shiftMask, xK_t), withFocused $ windows . W.sink), --Unfloat window
      ((modm, xK_v), pasteSelection), --Paste from selection buffer

      --Scratchpads
      ((modm .|. controlMask, xK_r), namedScratchpadAction scratchpads "ruby"),
      ((modm .|. controlMask, xK_w), namedScratchpadAction scratchpads "wiki"),

      --Browser search
      ((modm, xK_s), submap . M.fromList $
        [
          ((0, xK_g), selectSearch google),
          ((shiftMask, xK_g), promptSearch myXPConfig google),
          ((0, xK_d), selectSearch $ searchEngine "wiktionary" "https://en.wiktionary.org/wiki/"),
          ((shiftMask, xK_d), promptSearch myXPConfig $ searchEngine "wiktionary" "https://en.wiktionary.org/wiki/"),
          ((0, xK_w), selectSearch wikipedia),
          ((shiftMask, xK_w), promptSearch myXPConfig wikipedia),
          ((0, xK_u), getSelection >>= browserOpen),
          ((shiftMask, xK_u), prompt browser myXPConfig),
          ((0, xK_m), manPrompt myXPConfig),
          ((0, xK_c), spawn "rofi -modi 'clipboard:greenclip print' -show clipboard -run-command '{cmd}'")
        ])
    ]
    ++ --Swap adjacent workspaces
    [
      ((m .|. modm .|. controlMask, key), sc >>= screenWorkspace >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_l, xK_h] [(screenBy (-1)),(screenBy 1)]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
    ]

myMouseBindings :: XConfig Layout -> M.Map (KeyMask, Button) (Window -> X ())
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList
    [
      --Cycle through windows with scroll wheel
      ((modm, button4), \w -> focus w >> windows W.focusUp),
      ((modm, button5), \w -> focus w >> windows W.focusDown),
      --Resize master area with scroll wheel
      ((modm .|. shiftMask, button4), \w -> focus w >> sendMessage Expand),
      ((modm .|. shiftMask, button5), \w -> focus w >> sendMessage Shrink),

      ((controlMask, button3), mouseGesture $ M.fromList [
        ([U], \w -> focus w >> windowSwap U False),
        ([D], \w -> focus w >> windowSwap D False),
        ([L], \w -> focus w >> windowSwap L False),
        ([R], \w -> focus w >> windowSwap R False),
        ([U, D], \w -> focus w >> windows W.swapUp),
        ([D, U], \w -> focus w >> windows W.swapDown),
        ([L, R], \w -> focus w >> windowToScreen L False),
        ([R, L], \w -> focus w >> windowToScreen R False),
        ([R, U], \w -> focus w >> sendMessage NextLayout),
        ([L, U], \w -> focus w >> sendMessage FirstLayout),
        ([L, D], \_ -> sendMessage ToggleLayout),
        ([D, R], \_ -> kill)
      ])
    ]

main = xmonad $ fullscreenSupport $ withNavigation2DConfig def
    {
      --Add a fallback method so hjkl-navigation can't fail
      defaultTiledNavigation = hybridOf sideNavigation centerNavigation
    }
  $ def
    {
      terminal    = myTerminal,
      modMask     = modm,
      borderWidth = 1,
      normalBorderColor = "#000000",
      focusedBorderColor = "#00ff00",
      handleEventHook = handleEventHook def <+> fullscreenEventHook,
      manageHook = fullscreenManageHook >>
                   namedScratchpadManageHook scratchpads <+>
                   insertPosition Below Newer,
      layoutHook =  myLayoutHook,
      logHook = historyHook >> updatePointer (0.5, 0.5) (0.9, 0.9),
      keys = \c -> myKeys c `M.union` keys def c,
      mouseBindings = \c -> myMouseBindings c `M.union` mouseBindings def c,

      startupHook = do
        spawnOnce "picom &"
        spawnOnce "nitrogen --restore"
        spawnOnce "setxkbmap -layout dvorak -option caps:escape,altwin:menu_win,terminate:ctrl_alt_bksp"
        spawnOnce "greenclip daemon &"
    } `removeKeys` [(modm, xK_t)]
