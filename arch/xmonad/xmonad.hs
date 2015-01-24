import XMonad
import XMonad.Config.Xfce
import XMonad.Util.EZConfig
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.LayoutHints
import XMonad.Layout.Spacing

main = do xmonad $ ewmh xfceConfig 
		{ modMask = mod4Mask
		, terminal = "xfce4-terminal"
		, normalBorderColor = "#000000"
		, focusedBorderColor = "#f956a2"
		, borderWidth = 0
		, manageHook =  manageDocks <+> myManageHook
		, layoutHook = myLayout
		, logHook = myLogHook
		, handleEventHook = handleEventHook xfceConfig <+> fullscreenEventHook
		}`additionalKeys`
		[(( mod4Mask, xK_v), spawn "gvim")
		,(( mod4Mask, xK_w), spawn "firefox")
		,(( mod4Mask .|. shiftMask, xK_w), spawn "firefox -private-window")
		,(( mod4Mask, xK_a), spawn "xfce4-terminal -e music")
		,(( mod4Mask, xK_e), spawn "xfce4-terminal -e email")
		,(( mod4Mask, xK_c), spawn "xfce4-terminal -e irc")
		,(( mod4Mask, xK_z), spawn "zathura --fork")
		,(( mod4Mask, xK_d), spawn "xfce4-terminal --drop-down")
		,(( mod4Mask, xK_p), spawn "xfce4-popup-whiskermenu")
		,(( mod4Mask, xK_x), spawn "sh -c 'if pgrep xfce4-panel; then pkill xfce4-panel; else xfce4-panel --disable-wm-check; fi'")
		]

myLayout = spacey ||| full ||| fullscreen
	where
		spacey     = avoidStruts $ spacing 10 $ layoutHintsWithPlacement (0.5, 0.5) (Tall 1 (3/100) (1/2))
		full       = avoidStruts $ Full
		fullscreen = Full

myLogHook :: X()
myLogHook = fadeInactiveLogHook fadeAmount
	where fadeAmount = 0.7

myManageHook = composeAll
	[ className =? "Xfce4-notifyd" --> doIgnore
	, className =? "Conky"         --> doIgnore
	, className =? "Xfdesktop"     --> doIgnore

	, className =? "Gvbam"   --> doFloat
	, className =? "Skype"   --> doFloat
	, className =? "Wrapper" --> doFloat

	, className =? "Tint2" --> doHideIgnore
	]
