#!/usr/bin/env bash

# Configures OS X to the way I like it.
# This is entirely my own taste, but may be useful for
# other people who are interested in automating their own setup.

########################################
# Initial Setup
########################################

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Create an empty error log
ERROR_LOG=/tmp/setup_errors.log
touch $ERROR_LOG; rm $ERROR_LOG; touch $ERROR_LOG

########################################
# Homebrew & Cask
########################################

echo "Installing Homebrew..."

# Install Homebrew for package management
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Done"

########################################
# Base software Installation
########################################

echo "Installing dialog..."

brew install dialog

echo "Done"

# Determine which dialog software to use
read DIALOG <<< "$(which whiptail dialog 2> /dev/null)"

# Displays an infobox with $1 as the contents.
# $1: The contents of the infobox
infobox () {
	$DIALOG --infobox "$1" 12 50
}

# Displays a programbox with $2 as the text.
# $1: The command to run in the programbox
# $2: The text label
program_box () {
	infobox "$2"
	$1 2>> $ERROR_LOG 1> /dev/null
}

# Displays an input field with $1 as the label
# $1: The label for the input field
# Sets $user_input to the user’s input
get_input () {
	$DIALOG --inputbox "$1" 12 50 2> /tmp/userinput
	user_input=`cat /tmp/userinput`
}

# Displays a yes/no question with $1 as the prompt
# $1: The question prompt
# Sets $yes to true if the user answered yes, false otherwise
yes_no () {
	$DIALOG --yesno "$1" 12 50
	result=$?; yes=false; [ $result -eq 0 ] && yes=true
}

# Appends the given string to the given output file
# If the entire string is already present, it will not be appended
# $1: The string to append
# $2: The file to append to
append_entire_string_without_duplicating () {
	# If the entire string is already present...
	if [[ -z $(perl -ne "BEGIN{undef $/;} m|(\Q$1\E)| and print \$1" "$2") ]]; then
		sudo sh -c "echo -e \"\n$1\n\" >> $2"
	fi
}

options=(); i=0
packages=(bash bash-completion ctags caskroom/cask/brew-cask git)
for package in "${packages[@]}"
    do
		options+=($i $package "off")
        i=$[i+1]
done
cmd=($DIALOG --separate-output --no-tags --checklist "Choose Homebrew software to install:" 22 50 16)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

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
		cask_options=(); i=0
		cask_packages=(vagrant virtualbox d235j-xbox360-controller-driver)
		for package in "${cask_packages[@]}"
			do
				cask_options+=($i $package "off")
				i=$[i+1]
		done
		cask_cmd=($DIALOG --separate-output --no-tags --checklist "Choose Homebrew Cask software to install:" 22 50 16)
		cask_choices=$("${cask_cmd[@]}" "${cask_options[@]}" 2>&1 >/dev/tty)

		# Process user choices
		for cask_choice in $cask_choices; do
			cask_choice=${cask_packages[$cask_choice]} # Get the name of the choice

			program_box "brew cask install $cask_choice" "Installing ${cask_choice}..."

			case $cask_choice in
			esac
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

	NEW_HOSTNAME="$user_input"
	sudo scutil --set ComputerName $NEW_HOSTNAME
	sudo scutil --set LocalHostName $NEW_HOSTNAME
	sudo scutil --set HostName $NEW_HOSTNAME
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

# Use my own custom theme
TERM_PROFILE='inuBASHiri Dark Plain';
CURRENT_PROFILE="$(defaults read com.apple.terminal 'Default Window Settings')";
FONT='Meslo LG S Regular for Powerline.otf';
TMP_DIR="${HOME}/osx-setup-tmp";
if [ "${CURRENT_PROFILE}" != "${TERM_PROFILE}" ]; then
	mkdir -p $TMP_DIR

	# Install the necessary font
	curl -L https://github.com/powerline/fonts/raw/master/Meslo/Meslo%20LG%20S%20Regular%20for%20Powerline.otf -o "${HOME}/Library/Fonts/${FONT}" &> /dev/null

	curl -L https://raw.githubusercontent.com/nejsan/dotfiles/master/osx/terminal-themes/inuBASHiri%20Dark%20Plain.terminal -o "${TMP_DIR}/${TERM_PROFILE}.terminal" &> /dev/null
	open "${TMP_DIR}/${TERM_PROFILE}.terminal";
	sleep 1; # Wait a bit to make sure the theme is loaded

	curl -L https://raw.githubusercontent.com/nejsan/dotfiles/master/osx/terminal-themes/inuBASHiri%20Plain.terminal -o "${TMP_DIR}/inuBASHiri Plain.terminal" &> /dev/null
	open "${TMP_DIR}/inuBASHiri Plain.terminal";
	sleep 1; # Wait a bit to make sure the theme is loaded

	rm -rf $TMP_DIR

	defaults write com.apple.terminal 'Default Window Settings' -string "${TERM_PROFILE}";
	defaults write com.apple.terminal 'Startup Window Settings' -string "${TERM_PROFILE}";
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

sudo easy_install pip &> /dev/null # Silence the output
pip install --user powerline-status &> /dev/null # Silence the output

########################################
# Ruby gems (Compass)
########################################

infobox "Installing Ruby gems..."

sudo gem install compass &> /dev/null # Silence the output

########################################
# OS X Software Update
########################################

infobox "Opening OS X Software Update..."

# Open the App Store's software update page to check for new updates
open -a "Software Update"

infobox "Done. Enjoy your system!

You should reboot to apply some of these changes."
