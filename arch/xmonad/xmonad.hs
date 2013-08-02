import XMonad
import XMonad.Config.Xfce
import XMonad.Util.EZConfig
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.LayoutHints

main = do xmonad $ xfceConfig
		{ modMask = mod4Mask
		, terminal = "xfce4-terminal"
		, normalBorderColor  = "#000000"
		, focusedBorderColor = "#f956a2"
		, manageHook = myManageHook <+> manageHook xfceConfig
--		, layoutHook = myLayout
		}`additionalKeys`
		[(( mod4Mask, xK_v), spawn "gvim")
		,(( mod4Mask, xK_w), spawn "firefox")
		,(( mod4Mask .|. shiftMask, xK_w), spawn "firefox -private")
		,(( mod4Mask, xK_a), spawn "xfce4-terminal -e music")
		,(( mod4Mask, xK_e), spawn "xfce4-terminal -e checkmail")
		,(( mod4Mask, xK_c), spawn "xfce4-terminal -e irc")
		,(( mod4Mask, xK_z), spawn "zathura --fork")
		,(( mod4Mask, xK_d), spawn "xfce4-terminal --drop-down")
		]

--myLayout = avoidStruts $ layoutHintsWithPlacement (0.5, 0.5) (Tall 1 (3/100) (1/2)) ||| Full

myManageHook = composeAll
	[className =? "Xfce4-notifyd" --> doIgnore
	]
