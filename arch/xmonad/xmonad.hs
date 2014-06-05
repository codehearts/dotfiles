import XMonad
import XMonad.Config.Xfce
import XMonad.Util.EZConfig
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.LayoutHints
import XMonad.Layout.Spacing
-- Used for xmonad monitors
--import XMonad.Layout.LayoutModifier
--import XMonad.Layout.Monitor

main = do xmonad $ ewmh xfceConfig
		{ modMask = mod4Mask
		, terminal = "xfce4-terminal"
		, normalBorderColor  = "#000000"
		, focusedBorderColor = "#f956a2"
		, borderWidth = 0
		-- Append `manageMonitor panel` if using the panel monitor
		, manageHook =  manageDocks <+> myManageHook
		, layoutHook = myLayout
		, logHook = myLogHook
		, handleEventHook = handleEventHook xfceConfig <+> fullscreenEventHook
		}`additionalKeys`
		[(( mod4Mask, xK_v), spawn "gvim")
		,(( mod4Mask, xK_w), spawn "firefox")
		,(( mod4Mask .|. shiftMask, xK_w), spawn "firefox -private")
		,(( mod4Mask, xK_a), spawn "xfce4-terminal -e music")
		,(( mod4Mask, xK_e), spawn "xfce4-terminal -e checkmail")
		,(( mod4Mask, xK_c), spawn "xfce4-terminal -e irc")
		,(( mod4Mask, xK_z), spawn "zathura --fork")
		,(( mod4Mask, xK_d), spawn "xfce4-terminal --drop-down")
		-- Replace `xfce4-panel` with `tint2` if using tint2
		,(( mod4Mask, xK_x), spawn "sh -c 'if pgrep xfce4-panel; then pkill xfce4-panel; else xfce4-panel --disable-wm-check; fi'")
		,(( mod4Mask, xK_s), spawn "sh -c 'if pgrep conky; then pkill conky; else conky; fi'")
		-- Refreshes monitors, useful if using the panel monitor
		--,(( mod4Mask, xK_u), broadcastMessage ToggleMonitor >> refresh)
		]

{-
 -- xmonad monitor for a tint2 panel
panel = monitor {
      prop = ClassName "Tint2"
    , rect = Rectangle 0 (1080-30) 1920 30
    , persistent = True
    , visible = True
    , name = "panel"
    }
-}

-- Prepend `ModifiedLayout panel` if using the panel monitor
myLayout = spacing 10 $ avoidStruts $ layoutHintsWithPlacement (0.5, 0.5) (Tall 1 (3/100) (1/2)) ||| Full

myLogHook :: X()
myLogHook = fadeInactiveLogHook fadeAmount
	where fadeAmount = 0.7

myManageHook = composeAll
	[ className =? "Xfce4-notifyd" --> doIgnore
	, className =? "Conky" --> doIgnore
	, className =? "Tint2" --> doHideIgnore
	, className =? "Xfdesktop" --> doIgnore
	]
