# Linux

## bspwm

My tiling window manager of choice, configured by `$HOME/.config/bspwm/bspwmrc`. 10 desktops are defined and named using the kanji for 1-10.

### Rules

| Window | Rule | Description
| ------ | ---- | -----------
| XTerm:scratchpad | floating, sticky, and centered | Always-on-top scratchpad terminal

## sxhkd

Hotkey manager configured via `$HOME/.config/sxhkd/sxhkdrc`.

### Personal

Key     | Binding                     | Key | Binding
---     | -------                     | --- | -------
⌘+⏎     | xterm                       | ⌘+⎵ | dmenu_run
⌘+e     | firefox                     | ⌘+v | gvim
⌘+d     | xterm scratchpad            | ⌘+a | my `music` script
⌘+q     | my `bonjour` startup script | ⌘+z | my `dessiner` theming script
⌘+⌥+esc | quit bspwm

### Window Management

Key       | Binding                      | Key   | Binding
---       | -------                      | ---   | -------
⌘+{t,s,f} | tile/float/fullscreen window | ⌘+⇧+t | pseudo-tile window
⌘+w       | close window                 | ⌘+⇧+w | kill window
⌘+r       | rotate clockwise around window | ⌘+mouse{1..3} | move/resize side/resize corner of floating window

### Window Navigation

Key           | Binding                           | Key             | Binding
---           | -------                           | ---             | -------
⌘+{1..0}      | Focus desktop 1..10               | ⌘+⇧+{1..0}      | Move node to desktop 1..10
⌘+{h,j,k,l}   | Move focus in direction           | ⌘+⇧+{h,j,k,l}   | Move window in direction
⌘+⌥+{h,j,k,l} | Move floating/expand tiled window | ⌘+⇧+⌥+{h,j,k,l} | Resize floating/contract tiled window
⌘+`           | Focus last node                   | ⌘+↹             | Focus last desktop
⌘+{,⇧}c       | Focus next/previous node

### Window Creation

Key           | Binding                          | Key        | Binding
---           | -------                          | ---        | -------
⌘+⌃+{h,j,k,l} | preselect direction              | ⌘+⌃+{1..9} | preselect ratio
⌘+⌃+⎵         | cancel focused node preselection | ⌘+⇧+⌃+⎵    | cancel focused desktop preselection


## xinit

### Compose Key

The compose key is mapped to the menu key and can be used to type [complex character sequences](https://cgit.freedesktop.org/xorg/lib/libX11/plain/nls/en_US.UTF-8/Compose.pre).
