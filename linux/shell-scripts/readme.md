# Codehearts' Code-Bits

### mpc-notify
##### bash 4+ | curl | ffmpeg | mogrify (imagemagick) | mpc | notify-send (libnotify)

Sends a notification using notify-send with artwork and information from mpc. Album art is extracted with ffmpeg and downloaded from [coverartarchive.org](http://coverartarchive.org) if it's missing. Downloaded artwork is embedded into the audio file to avoid downloading it again.

Downloading takes a while, so it's recommended to run this script backgrounded. If [coverartarchive.org](http://coverartarchive.org) doesn't have your artwork this script will default to `audio-x-generic` and attempt to download every time. You can either add the artwork to their database, embed artwork yourself, or mod this script to ignore your file or embed a default image.

#### Using with ncmpcpp
Use the following in your ncmpcpp config, assuming `mpc-notify` is on your `$PATH`.

    execute_on_song_change = "mpc-notify &"
