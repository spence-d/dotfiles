import XMonad
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig
import XMonad.Layout.Gaps
import XMonad.Layout.Spacing
import XMonad.Layout.Fullscreen
import XMonad.Layout.Grid
import XMonad.Actions.GroupNavigation
import XMonad.Actions.Navigation2D
import XMonad.Actions.WindowGo

myLayoutHook = gapped ||| Mirror gapped ||| Grid ||| Full
  where tiled = Tall 1 (3/100) (1/2)
        gapped = spacing 5 $ gaps [(U,8), (R,8), (L,8), (D,8)] tiled

modm = mod4Mask

main = xmonad $ fullscreenSupport $ def
    {
      terminal    = "kitty",
      modMask     = modm,
      borderWidth = 0,
      normalBorderColor = "#000000",
      focusedBorderColor = "#00ff00",
      handleEventHook = handleEventHook def <+> fullscreenEventHook,
      manageHook = fullscreenManageHook,
      layoutHook = myLayoutHook,
      logHook = historyHook,
      startupHook = do
        spawnOnce "picom &"
        spawnOnce "nitrogen --restore"
        spawnOnce "setxkbmap -layout dvorak -option caps:escape"
    }
  `additionalKeys`
    [
      --Spawn keys
      ((modm, xK_p), spawn "rofi -show combi"),
      ((modm, xK_b), spawn "vivaldi-stable"),
      ((modm .|. shiftMask, xK_b), runOrRaiseNext "vivaldi-stable" (resource =? "vivaldi-stable")),
      ((modm, xK_Return), spawn "kitty"),
      ((modm .|. shiftMask, xK_Return), runOrRaiseNext "kitty" (className =? "kitty")),

      --Vim navigation keys
      ((modm, xK_h), windowGo L False),
      ((modm, xK_j), windowGo D False),
      ((modm, xK_k), windowGo U False),
      ((modm, xK_l), windowGo R False),
      ((modm .|. shiftMask, xK_h), windowSwap L False),
      ((modm .|. shiftMask, xK_j), windowSwap D False),
      ((modm .|. shiftMask, xK_k), windowSwap U False),
      ((modm .|. shiftMask, xK_l), windowSwap R False),

      --Toggle back and forth between two recent windows
      ((modm, xK_BackSpace), nextMatch History (return True))
    ]
