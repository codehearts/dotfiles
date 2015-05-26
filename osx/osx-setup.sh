#!/usr/bin/env bash

# Configures OS X to the way I like it.
# This is entirely my own taste, but may be useful for
# other people who are interested in automating their own setup.

########################################
# Initial Setup
########################################

# Determine which directory this script is in
osx_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Include the utility script
. "$osx_dir/../scripts/utility.sh"

########################################
# Homebrew & Cask
########################################

is_command_installed brew
if ! $installed; then
	echo "Installing Homebrew..."

	# Install Homebrew for package management
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

	echo "Done"
fi

########################################
# Base software Installation
########################################

is_command_installed dialog
if ! $installed; then
	echo "Installing dialog..."

	brew install dialog

	echo "Done"
fi

# Include the dialog script
. "$osx_dir/../scripts/dialog.sh"

########################################
# Brew software Installation
########################################

packages=( bash bash-completion ctags caskroom/cask/brew-cask git )
defaults=( "on" "on"            "on"  "on"                    "on")

checklist "Choose Homebrew software to install:" packages[@] defaults[@]

# Process user choices
for choice in $choices; do
	choice=${packages[$choice]} # Get the name of the choice
	program_box "brew install $choice" "Installing ${choice}..."

	case $choice in
	bash)
		yes_no "Use Homebrew's bash as the default shell?"
		if $yes; then
			append_entire_string_without_duplicating "/usr/local/bin/bash" /etc/shells
			program_box "sudo chsh -s /usr/local/bin/bash $(whoami)" "Changing default shell..."
		fi
		;;
	caskroom/cask/brew-cask)
		# Allow the user to install Cask packages
		packages=( vagrant virtualbox d235j-xbox360-controller-driver)
		defaults=( "on"    "on"       "on"                           )

		checklist "Choose Homebrew Cask software to install:" packages[@] defaults[@]

		# Process user choices
		for choice in $choices; do
			choice=${packages[$choice]} # Get the name of the choice
			program_box "brew cask install $choice" "Installing ${choice}..."
		done
		;;
	esac
done

########################################
# System Preferences
########################################

# Set the computer's name and hostname
yes_no "Set this machine's hostname?"
if $yes; then
	get_input "Choose a hostname for this computer\nDon't forget that it can't have spaces!"

	sudo scutil --set ComputerName "$user_input"
	sudo scutil --set LocalHostName "$user_input"
	sudo scutil --set HostName "$user_input"
fi

infobox "Configuring system preferences..."

# Set highlight color to pink
defaults write NSGlobalDomain AppleHighlightColor -string "1.000000 0.749020 0.823529"

# Jump to the spot that's clicked on the scroll bar
defaults write NSGlobalDomain AppleScrollerPagingBehavior -int 1

# Never start the screensaver
defaults write com.apple.screensaver idleTime 0

# Use a 24 hour clock
defaults write NSGlobalDomain AppleICUForce24HourTime -bool true

# Put the display to sleep after 8 minutes on battery
sudo pmset -b displaysleep 8

# Expand save and print panels by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Play a feedback sound when adjusting volume
defaults write NSGlobalDomain com.apple.sound.beep.feedback -int 1

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: use four finger horizontal swipe to move between fullscreen apps
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerHorizSwipeGesture -int 2

# Trackpad: use four finger vertical swipe for mission control
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerVertSwipeGesture -int 2

# Use scroll gesture with the Ctrl (^) modifier key to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Hide icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

########################################
# Git
########################################

infobox "Configuring Git..."

# Fixes an issue with tracking files with unicode in their name
git config --global core.precomposeunicode true

########################################
# Safari
########################################

infobox "Configuring Safari..."

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true

########################################
# Terminal.app
########################################

infobox "Configuring Terminal..."

# Use UTF-8
defaults write com.apple.terminal StringEncodings -array 4

# Use my own themes
tmp_dir="${HOME}/osx-setup-tmp";
term_profile='inuBASHiri Dark Plain';
current_profile="$(defaults read com.apple.terminal 'Default Window Settings')";
profile_dir_url='https://raw.githubusercontent.com/nejsan/dotfiles/master/osx/terminal-themes'
font_url='https://github.com/powerline/fonts/raw/master/Meslo/Meslo%20LG%20S%20Regular%20for%20Powerline.otf'
font='Meslo LG S Regular for Powerline.otf';
if [ "${current_profile}" != "${term_profile}" ]; then
	mkdir -p $tmp_dir

	# Install the necessary font if it is not already present
	if [ ! -f "${HOME}/Library/Fonts/${font}" ]; then
		curl -Ls "${font_url}" -s -o "${HOME}/Library/Fonts/${font}"
	fi

	curl -L "${profile_dir_url}/inuBASHiri%20Dark%20Plain.terminal" -s -o "${tmp_dir}/${term_profile}.terminal"
	open "${tmp_dir}/${term_profile}.terminal";
	sleep 1; # Wait a bit to make sure the theme is loaded

	curl -L "${profile_dir_url}/inuBASHiri%20Plain.terminal" -s -o "${tmp_dir}/inuBASHiri Plain.terminal"
	open "${tmp_dir}/inuBASHiri Plain.terminal";
	sleep 1; # Wait a bit to make sure the theme is loaded

	rm -rf $tmp_dir

	defaults write com.apple.terminal 'Default Window Settings' -string "${term_profile}";
	defaults write com.apple.terminal 'Startup Window Settings' -string "${term_profile}";
fi;

########################################
# TextEdit
########################################

infobox "Configuring TextEdit..."

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0

# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

########################################
# Messages
########################################

infobox "Configuring Messages..."

# Disable automatic emoji substitution (i.e. use plain text smileys)
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false

########################################
# Python packages (Powerline)
########################################

infobox "Installing Python packages..."

sudo easy_install pip
pip install --user powerline-status

########################################
# Ruby gems (Compass)
########################################

infobox "Installing Ruby gems..."

sudo gem install compass

########################################
# OS X Software Update
########################################

infobox "Opening OS X Software Update..."

# Open the App Store's software update page to check for new updates
open -a "Software Update"

infobox "Done. Enjoy your system!

You should reboot to apply some of these changes."
