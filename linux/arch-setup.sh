#!/usr/bin/env bash

# Configures Arch Linux to the way I like it.
# This is entirely my own taste, but may be useful for
# other people who are interested in automating their own setup.

########################################
# Initial Setup
########################################

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

########################################
# Base software Installation
########################################

echo "Installing whiptail"

sudo pacman --noconfirm -S libnewt

echo "Done"

# Determine which dialog software to use
read DIALOG <<< "$(which whiptail dialog 2> /dev/null)"

# Set our package manager command
pkg_mgr=pacman

# Displays an infobox with $1 as the contents.
# $1: The contents of the infobox
infobox () {
	$DIALOG --infobox "$1" 12 50
}

# Displays a programbox with $2 as the text.
# $1: The command to run in the programbox
# $2: The text label
program_box () {
	$1 | $DIALOG --programbox "$2" 12 50
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
# Returns 0 for "yes" and 1 for "no"
yes_no () {
	$DIALOG --yesno "$1" 12 50
}

########################################
# Yaourt
########################################

yes_no "Install yaourt?"
if $yes; then
	curl -O https://aur.archlinux.org/packages/pa/package-query/package-query.tar.gz
	tar zxvf package-query.tar.gz
	cd package-query
	makepkg -si
	cd ..
	curl -O https://aur.archlinux.org/packages/ya/yaourt/yaourt.tar.gz
	tar zxvf yaourt.tar.gz
	cd yaourt
	makepkg -si
	cd ..
	rm -rf yaourt package-query

	pkg_mgr=yaourt
fi

########################################
# CLI Software
########################################

options=(); i=0
packages=(bash-completion calc ctags dictd gcalcli gnome-keyring grub2-theme-dharma-mod htop msmtp mutt mutt-sidebar ncmpcpp offlineimap python-pip python2-pip rsync texlive-core texlive-humanities texlive-pictures tmux unzip urlview vagrant virtualbox virtualbox-guest-utils)
for package in "${packages[@]}"; do
	# Don't allow AUR packages if yaourt isn't installed
	if "$pkg_mgr" != "yaourt"; then
		case $package in
			gcalcli) ;&
			grub2-theme-dharma-mod) ;&
			mutt-sidebar) ;&
			urlview)
				continue
			;;
		esac
	fi

	# Default certain packages I don't use to "off"
	case $package in
	mutt)
		options+=($i $package "off")
		;;
	*)
		options+=($i $package "on")
		;;
	esac

	i=$[i+1]
done
cmd=($DIALOG --separate-output --no-tags --checklist "Choose software to install:" 22 50 16)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

# Process user choices
for choice in $choices; do
	choice=${packages[$choice]} # Get the name of the choice

	program_box "sudo $pkg_mgr --noconfirm -S $choice" "Installing ${choice}..."

	case $choice in
	bash)
		yes_no "Use Homebrew's bash as the default shell?"
		if $yes; then
			append_entire_string_without_duplicating "/usr/local/bin/bash" /etc/shells
			program_box "sudo chsh -s /usr/local/bin/bash $(whoami)" "Changing default shell..."
		fi
		;;
	esac
done



yes_no "Install X server?"
if $yes; then

	########################################
	# X Server
	########################################

	clear
	sudo pacman --noconfirm -S xorg-server xf86-input-synaptics

	options=(); i=0
	packages=(xfce4-appfinder xfce4-panel xfce4-power-manager xfce4-session xfce4-settings xfce4-terminal xfdesktop xfwm4)
	for package in "${packages[@]}"; do
		# Default certain packages I use to "on"
		case $package in
		xfce4-panel) ;& # Fall through
		xfce4-power-manager) ;&
		xfce4-session) ;&
		xfce4-settings) ;&
		xfce4-terminal) ;&
		xfce4-whiskermenu-plugin)
			options+=($i $package "on")
			;;
		*)
			options+=($i $package "off")
			;;
		esac

		i=$[i+1]
	done
	cmd=($DIALOG --separate-output --no-tags --checklist "Choose XFCE components to install:" 22 50 16)
	choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

	# Process user choices
	for choice in $choices; do
		choice=${packages[$choice]} # Get the name of the choice

		program_box "sudo $pkg_mgr --noconfirm -S $choice" "Installing ${choice}..."

		case $choice in
		# Allow the user to install XFCE Panel goodies
		xfce4-panel)
			panel_options=(); i=0
			panel_packages=(xfce4-mailwatch-plugin xfce4-weather-plugin xfce4-weather-plugin)
			for package in "${panel_packages[@]}"; do
				panel_options+=($i $package "on")
				i=$[i+1]
			done
			panel_cmd=($DIALOG --separate-output --no-tags --checklist "Choose XFCE Panel goodies to install:" 22 50 16)
			panel_choices=$("${cask_cmd[@]}" "${cask_options[@]}" 2>&1 >/dev/tty)

			# Process user choices
			for panel_choice in $panel_choices; do
				panel_choice=${panel_packages[$panel_choice]} # Get the name of the choice

				program_box "sudo $pkg_mgr --noconfirm -S $panel_choice" "Installing ${panel_choice}..."

				case $panel_choice in
				esac
			done
			;;
		esac
	done

	########################################
	# Graphical Software
	########################################

	options=(); i=0
	packages=(accountsservice adobe-source-sans-pro-fonts chromium google-chrome compton dropbox faba-mono-icons-git feh firefox gcalert gtk-theme-iris-dark-git gvim lightdm-gtk-greeter lightdm-webkit-theme-bevel-git mpdnotify-git rdesktop scrot slock tightvnc xmonad-contrib zathura-pdf-mupdf)
	for package in "${packages[@]}"; do
		# Don't allow AUR packages if yaourt isn't installed
		if "$pkg_mgr" != "yaourt"; then
			case $package in
				google-chrome) ;&
				compton) ;&
				dropbox) ;&
				faba-mono-icons-git) ;&
				gcalert) ;&
				gtk-theme-iris-dark-git) ;&
				lightdm-webkit-theme-bevel-git) ;&
				mpdnotify-git) ;&
				tightvnc)
					continue
				;;
			esac
		fi

		# Default certain packages I use to "on"
		case $package in
		accountsservice) ;& # Fall through
		adobe-source-sans-pro-fonts) ;&
		compton) ;&
		dropbox) ;&
		faba-mono-icons-git) ;&
		feh) ;&
		firefox) ;&
		gcalert) ;&
		gtk-theme-iris-dark-git) ;&
		gvim) ;&
		lightdm-webkit-theme-bevel-git) ;&
		rdesktop) ;&
		scrot) ;&
		slock) ;&
		tightvnc) ;&
		xmonad-contrib) ;&
		zathura-pdf-mupdf)
			options+=($i $package "on")
			;;
		*)
			options+=($i $package "off")
			;;
		esac

		i=$[i+1]
	done
	cmd=($DIALOG --separate-output --no-tags --checklist "Choose XFCE components to install:" 22 50 16)
	choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

	# Process user choices
	for choice in $choices; do
		choice=${packages[$choice]} # Get the name of the choice

		program_box "sudo $pkg_mgr --noconfirm -S $choice" "Installing ${choice}..."

		case $choice in
		esac
	done
fi

infobox "Done. Enjoy your system!"
