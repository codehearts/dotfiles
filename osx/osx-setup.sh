#!/usr/bin/env bash

# Configures OS X to the way I like it.
# This is entirely my own taste, but may be useful for
# other people who are interested in automating their own setup.

echo "Configuring system settings!"

########################################
# Initial Setup Setup
########################################

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &



########################################
# Homebrew & Cask
########################################
echo "Installing Homebrew and Cask..."

# Install Homebrew for package management and Cask to install apps through Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install caskroom/cask/brew-cask



echo "Done"
########################################
# Software Installation
########################################
echo "Installating software..."

brew install \
  dialog \
  git

brew cask install \
  anki \
  dropbox \
  espresso \
  firefox \
  google-chrome \
  gopanda \
  macvim \
  omnigraffle \
  opera \
  paparazzi \
  sequel-pro \
  skype \
  steam \
  supercollider \
  textmate \
  vlc \
  xmarks-safari



echo "Done"
########################################
# System Preferences
########################################
echo "Configuring system preferences..."

# Set highlight color to pink
defaults write NSGlobalDomain AppleHighlightColor -string "1.000000 0.749020 0.823529"

# Jump to the spot that's clicked on the scroll bar
defaults write NSGlobalDomain AppleScrollerPagingBehavior -bool false

# Never start the screensaver
defaults write com.apple.screensaver idleTime 0

# Use a 24 hour clock
defaults write NSGlobalDomain AppleICUForce24HourTime -bool true

# Download and set my wallpaper
WALLPAPER=dieter-rams-vitsoe-606.jpg
mkdir -p ~/Pictures/Wallpapers
curl https://raw.githubusercontent.com/nejsan/dotfiles/master/osx/Pictures/Wallpapers/$WALLPAPER -O ~/Pictures/Wallpapers/$WALLPAPER
rm -rf ~/Library/Application Support/Dock/desktoppicture.db
sudo ln -sf ~/Pictures/Wallpapers/$WALLPAPER /System/Library/CoreServices/DefaultDesktop.jpg

# Enable Japanese language input (Kotoeri)
# TODO Confirm that this works as expected
defaults write NSGlobalDomain AppleLanguages -array "en" "ja"
defaults write com.apple.inputmethod.Kotoeri JIMPrefVersionKey 1

# Put the display to sleep after 8 minutes on battery
sudo pmset -b displaysleep 8

# Expand save and print panels by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

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



echo "Done"
########################################
# Safari
########################################
echo "Configuring Safari..."

# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true



echo "Done"
########################################
# Terminal.app
########################################
echo "Configuring Terminal..."

# Use UTF-8
defaults write com.apple.terminal StringEncodings -array 4

# Use my own custom theme
TERM_PROFILE='inuBASHiri Dark Plain';
CURRENT_PROFILE="$(defaults read com.apple.terminal 'Default Window Settings')";
TMP_DIR='~/osx-setup-tmp';
if [ "${CURRENT_PROFILE}" != "${TERM_PROFILE}" ]; then
	mkdir -p $TMP_DIR
	curl https://raw.githubusercontent.com/nejsan/dotfiles/master/osx/terminal-themes/inuBASHiri%20Dark%20Plain.terminal -o "${TMP_DIR}/${TERM_PROFILE}.terminal"
	curl https://raw.githubusercontent.com/nejsan/dotfiles/master/osx/terminal-themes/inuBASHiri%20Plain.terminal -o "${TMP_DIR}/inuBASHiri Plain.terminal"
	open "~/osx-setup-tmp/${TERM_PROFILE}.terminal";
	sleep 1; # Wait a bit to make sure the theme is loaded
	open "~/osx-setup-tmp/inuBASHiri Plain.terminal";
	sleep 1; # Wait a bit to make sure the theme is loaded
	rm -rf ~/osx-setup-tmp
	defaults write com.apple.terminal 'Default Window Settings' -string "${TERM_PROFILE}";
	defaults write com.apple.terminal 'Startup Window Settings' -string "${TERM_PROFILE}";
fi;



echo "Done"
########################################
# TextEdit
########################################
echo "Configuring TextEdit..."

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0

# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4



echo "Done"
########################################
# Messages
########################################
echo "Configuring Messages..."

# Disable automatic emoji substitution (i.e. use plain text smileys)
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false



echo "Done"
########################################
# OS X Software Update
########################################
echo "Opening OS X Software Update..."

# Open the App Store's software update page to check for new updates
open -a "Software Update"

echo "Done
echo "\nEnjoy the system!"
