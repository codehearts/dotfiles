# Codehearts' Code-Bits

### bonjour
##### pgrep | pkill

Applies colorschemes and starts any daemons that aren't already running. If any of the supported colorschemes or daemons aren't installed, they will be ignored.

### dessiner
##### bonjour (custom script, optional) | dmenu or rofi | python (optional) | python-haishoku (optional) | wal

Sets the system theme from the colors in the given wallpaper in `$HOME/Pictures/wallpaper`, or uses dmenu/rofi to select a wallpaper. Colors will be determined using haishoku if available or using wal's default implemention if not. If my bonjour script is also installed then it will be run afterwards to restart any daemons that won't automatically detect the new colors.

### mail-notify
##### bash 4+ | grep | notify-send (libnotify)

Sends notifications for new emails using notify-send with the from and subject headers. New mail is taken from `$MAIL_DIR/*/Inbox/new/`, which should work with most offlineimap setups. Run this script periodically with `-a $RUN_INTERVAL` to notify of new mail since the last run.

### mpc-notify
##### bash 4+ | curl | ffmpeg | mogrify (imagemagick) | mpc | notify-send (libnotify)

Sends a notification using notify-send with artwork and information from mpc. Album art is extracted with ffmpeg and downloaded from [coverartarchive.org](http://coverartarchive.org) if it's missing. Downloaded artwork is embedded into the audio file to avoid downloading it again.

Downloading takes a while, so it's recommended to run this script backgrounded. If [coverartarchive.org](http://coverartarchive.org) doesn't have your artwork this script will default to `audio-x-generic` and attempt to download every time. You can either add the artwork to their database, embed artwork yourself, or mod this script to ignore your file or embed a default image.

#### Using with ncmpcpp
Use the following in your ncmpcpp config, assuming `mpc-notify` is on your `$PATH`.

    execute_on_song_change = "mpc-notify &"
