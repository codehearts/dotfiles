# Uses setdown.sh to install packages and set preferences I want.
#
# Author: Kate Hart (https://github.com/codehearts)
# Depends: setdown.sh

# Determines if a package is installed on macOS with homebrew
# if brew_haspkg ruby; then echo 'has ruby'; fi
brew_haspkg() { brew ls --versions $1 >/dev/null 2>&1; }

# Adds a package choice to an array if the brew package is not installed
# brew_addpkg my_choices firefox on
brew_addpkg() { local -n array=$1; brew_haspkg "$2" || array+=($2 $3); }

# Asks the user to select packages and adds them to the package array
# brew_getpkgs 'Select software to install' my_choices
brew_getpkgs() {
  declare -a choices=$(setdown_getopts "$1" $2)
  packages+=("${choices[@]}")
}

# List of brew cask packages to install
declare -a packages_cask

# Determines if a package is installed on macOS with homebrew cask
# if cask_haspkg firefox; then echo 'has firefox'; fi
cask_haspkg() { brew cask ls --versions $1 >/dev/null 2>&1; }

# Adds a package choice to an array if the cask package is not installed
# cask_addpkg my_choices firefox on
cask_addpkg() { local -n array=$1; cask_haspkg "$2" || array+=($2 $3); }

# Asks the user to select packages and adds them to the packages_cask array
# cask_getpkgs 'Select software to install' my_choices
cask_getpkgs() {
  declare -a choices=$(setdown_getopts "$1" $2)
  packages_cask+=("${choices[@]}")
}

#
# Install homebrew and dialog if missing
#

if ! setdown_hascmd brew; then
  BREW_URL=https://raw.githubusercontent.com/Homebrew/install/master/install
  ruby -e "$(curl -fsSL $BREW_URL)"
fi

! setdown_hascmd dialog && setdown_hascmd brew && brew install dialog

# Install bash via homebrew to ensure bash 4+ is used
if [ ! -f /usr/local/bin/bash ] && setdown_hascmd brew; then
  brew install bash

  if setdown_sudo 'Enter password to set bash from homebrew as default shell'; then
    setdown_putcmd sudo sh -c 'sudo echo /usr/local/bin/bash >> /etc/shells'
    setdown_putcmd sudo chsh -s /usr/local/bin/bash "$(whoami)"

    # Rerun this script using bash from homebrew
    /usr/local/bin/bash -c "${0} ${@}"
    exit
  else
    setdown_putstr_ok 'Skipping brew bash shell setup'
  fi
fi

#
# Ask for and install brew packages
#

declare -a brew_packages

brew_addpkg brew_packages bash-completion on
brew_addpkg brew_packages ctags           on
brew_addpkg brew_packages ffmpeg          on
brew_addpkg brew_packages git             on
brew_addpkg brew_packages python          on
brew_addpkg brew_packages python3         on
brew_addpkg brew_packages ruby            on
brew_addpkg brew_packages thefuck         on

brew_getpkgs 'Homebrew packages' brew_packages

if [ "${#packages[@]}" -gt 0 ]; then
  if setdown_sudo 'Enter password to install brew packages'; then
    setdown_putcmd brew install "${packages[@]}"
  else
    setdown_putstr_ok 'Skipping brew package install'
  fi
fi

#
# Ask for and install brew cask packages
#

declare -a cask_packages

cask_addpkg cask_packages d235j-xbox360-controller-driver off
cask_addpkg cask_packages iina                            on
cask_addpkg cask_packages qlmarkdown                      on
cask_addpkg cask_packages qlstephen                       on

brew_getpkgs 'Homebrew cask packages' cask_packages

if [ "${#packages_cask[@]}" -gt 0 ]; then
  if setdown_sudo 'Enter password to install brew cask packages'; then
    setdown_putcmd brew cask install "${packages_cask[@]}"
  else
    setdown_putstr_ok 'Skipping brew cask package install'
  fi
fi

#
# Add installed cask packages to the packages array
#

packages+=("${packages_cask[@]}")

#
# Copy terminal themes
#

default_terminal_theme='NejThayer';

has_terminal_theme() {
  defaults read com.apple.terminal "NSWindow Frame TTWindow $1" >/dev/null 2>&1
}

# Install each theme if it is not already installed
for theme in $MACOS_DIR/terminal-themes/*; do
  if ! has_terminal_theme "$(basename -s .terminal "$theme")"; then
		open "$theme";
		sleep 1; # Wait a bit to make sure the theme is loaded
	fi
done

#
# Set the hostname
#

new_hostname=`setdown_getstr "Hostname" "$HOSTNAME"`
if [ "$new_hostname" != "$HOSTNAME" ]; then
  if setdown_sudo 'Enter password to set hostname'; then
    setdown_putcmd sudo scutil --set ComputerName  "$new_hostname"
    setdown_putcmd sudo scutil --set LocalHostName "$new_hostname"
    setdown_putcmd sudo scutil --set HostName      "$new_hostname"
    export HOSTNAME="$new_hostname"
  else
    setdown_putstr_ok 'Skipping hostname'
  fi
fi

#
# Set preferences
#

if setdown_sudo 'Enter password to set sleep timer'; then
  # Put the display to sleep after 8 minutes on battery
  setdown_putcmd sudo pmset -b displaysleep 8
else
  setdown_putstr_ok 'Skipping sleep timer'
fi

pref='setdown_putcmd defaults write'
pref_general="$pref NSGlobalDomain"
pref_access="$pref com.apple.universalaccess"
pref_dock="$pref com.apple.dock"
pref_finder="$pref com.apple.finder"
pref_safari="$pref com.apple.Safari"
pref_screensaver="$pref com.apple.screensaver"
pref_terminal="$pref com.apple.terminal"
pref_textedit="$pref com.apple.TextEdit"
pref_trackpad="$pref com.apple.driver.AppleBluetoothMultitouch.trackpad"

# Don't display accented characters when holding a key
defaults write -g ApplePressAndHoldEnabled -bool false

# Pink highlight color
$pref_general AppleHighlightColor -string "1.000000 0.749020 0.823529"

# Jump to the spot that's clicked on the scroll bar
$pref_general AppleScrollerPagingBehavior -int 1

# Save to disk (not to iCloud) by default (restart Finder)
$pref_general NSDocumentSaveNewDocumentsToCloud -bool false

# Expand save and print panels by default
$pref_general NSNavPanelExpandedStateForSaveMode  -bool true
$pref_general NSNavPanelExpandedStateForSaveMode2 -bool true
$pref_general PMPrintingExpandedStateForPrint     -bool true
$pref_general PMPrintingExpandedStateForPrint2    -bool true

# Use a 24 hour clock (restart SystemUIServer)
$pref_general AppleICUForce24HourTime -bool true

# Use celsius
$pref_general AppleTemperatureUnit -string "Celsius"

# Play a feedback sound when adjusting volume
$pref_general com.apple.sound.beep.feedback -int 1

# Never start the screensaver
$pref_screensaver idleTime 0

# Screensaver: Require password immediately after sleep or screen saver begins (removed from High Sierra)
#$pref_screensaver askForPassword -int 1
#$pref_screensaver askForPasswordDelay -int 0

# Trackpad: enable tap to click for this user and for the login screen (removed from High Sierra)
#setdown_putcmd defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
#$pref_general com.apple.mouse.tapBehavior -int 1
#$pref_trackpad Clicking -bool true

# Trackpad: use four finger horizontal swipe to move between fullscreen apps
$pref_trackpad TrackpadThreeFingerHorizSwipeGesture -int 0
$pref_trackpad TrackpadFourFingerHorizSwipeGesture -int 2

# Trackpad: use four finger vertical swipe for mission control
$pref_trackpad TrackpadThreeFingerVertSwipeGesture -int 0
$pref_trackpad TrackpadFourFingerVertSwipeGesture -int 2

# Accessibility: Use scroll gesture with the Ctrl (^) modifier key to zoom (requires restart)
$pref_access closeViewScrollWheelToggle -bool true
$pref_access HIDScrollZoomModifierMask -int 262144

# Finder: Hide desktop icons for hard drives, servers, and removable media (restart Finder)
$pref_finder ShowExternalHardDrivesOnDesktop -bool false
$pref_finder ShowHardDrivesOnDesktop -bool false
$pref_finder ShowMountedServersOnDesktop -bool false
$pref_finder ShowRemovableMediaOnDesktop -bool false

# Finder: Use current directory as default search scope
$pref_finder FXDefaultSearchScope -string "SCcf"

# Finder: Display files as an icon grid
$pref_finder FXPreferredViewStyle -string "icnv"

# Finder: Don't warn when emptying the trash
$pref_finder WarnOnEmptyTrash -bool false

# Dock: Automatically hide and show (restart Dock)
$pref_dock autohide -bool true

# Safari: Enable the develop menu and web inspector
$pref_safari IncludeDevelopMenu -bool true

# TextEdit: Use plain text mode for new documents
$pref_textedit RichText -int 0

# TextEdit: Open and save files as UTF-8
$pref_textedit PlainTextEncoding         -int 4
$pref_textedit PlainTextEncodingForWrite -int 4

# Terminal: Use UTF-8
$pref_terminal StringEncodings -array 4

# Terminal: Use my default theme
$pref_terminal 'Default Window Settings' -string "$default_terminal_theme";
$pref_terminal 'Startup Window Settings' -string "$default_terminal_theme";

# Restart services to apply changes
killall -KILL SystemUIServer
killall -KILL Finder
killall -KILL Dock
