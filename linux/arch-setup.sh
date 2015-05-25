#!/usr/bin/env bash

# Configures Arch Linux to the way I like it.
# This is entirely my own taste, but may be useful for
# other people who are interested in automating their own setup.

########################################
# Initial Setup
########################################

# Set our package manager command
pkg_mgr="sudo pacman"

# Determine which directory this script is in
linux_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

########################################
# Dialog Software Install
########################################

echo "Installing whiptail"

$pkg_mgr --noconfirm -S libnewt

echo "Done"

# Include the dialog script
. "$linux_dir/../scripts/dialog.sh"

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

packages=( bash-completion calc ctags dictd  gnome-keyring  htop )
defaults=( "on"            "on" "on"  "on"   "on"           "on" )
packages+=(msmtp mutt  ncmpcpp offlineimap python-pip python2-pip)
defaults+=("on"  "off" "on"    "on"        "on"       "on"       )
packages+=(rsync texlive-core texlive-humanities texlive-pictures)
defaults+=("on"  "on"         "on"               "on"            )
packages+=(tmux unzip vagrant virtualbox virtualbox-guest-utils  )
defaults+=("on" "on"  "on"    "on"       "on"                    )

# Add yaourt packages if yaourt was installed
if "$pkg_mgr" == "yaourt"; then
	packages+=(gcalcli grub2-theme-dharma-mod mutt-sidebar urlview)
	defaults+=("on"    "on"                   "on"         "on"   )
fi

checklist "Choose software to install:" $packages $defaults

# Process user choices
for choice in $choices; do
	choice=${packages[$choice]} # Get the name of the choice
	program_box "$pkg_mgr --noconfirm -S $choice" "Installing ${choice}..."
done

########################################
# Graphical Software
########################################

yes_no "Install X server?"
if $yes; then

	########################################
	# X Server
	########################################

	clear
	sudo $pkg_mgr --noconfirm -S xorg-server xf86-input-synaptics

	packages=( xfce4-panel xfce4-power-manager xfce4-session xfce4-settings)
	defaults=( "on"        "on"                "on"          "on"          )
	packages+=(xfce4-terminal xfdesktop xfwm4                              )
	defaults+=("on"           "off"     "off"                              )

	checklist "Choose XFCE components to install:" $packages $defaults

	# Process user choices
	for choice in $choices; do
		choice=${packages[$choice]} # Get the name of the choice

		program_box "$pkg_mgr --noconfirm -S $choice" "Installing ${choice}..."

		case $choice in
		# Allow the user to install XFCE Panel goodies
		xfce4-panel)
			packages=( xfce4-mailwatch-plugin xfce4-weather-plugin xfce4-weather-plugin)
			defaults=( "on"                   "on"                 "on"                )
			packages+=(xfce4-whiskermenu-plugin                                        )
			defaults+=("on"                                                            )

			checklist "Choose XFCE panel goodies to install:" $packages $defaults

			# Process user choices
			for choice in $choices; do
				choice=${packages[$choice]} # Get the name of the choice
				program_box "$pkg_mgr --noconfirm -S $choice" "Installing ${choice}..."
			done
			;;
		esac
	done

	########################################
	# Graphical Software
	########################################

	packages=( accountsservice adobe-source-sans-pro-fonts chromium feh  firefox)
	defaults=( "on"            "on"                        "off"    "on" "on"   )
	packages+=(gvim lightdm-gtk-greeter rdesktop scrot slock tigervnc           )
	defaults+=("on" "off"               "on"     "on"  "on"  "on"               )
	packages+=(xmonad-contrib zathura-pdf-mupdf                                 )
	defaults+=("on"           "on"                                              )

	# Add yaourt packages if yaourt was installed
	if "$pkg_mgr" == "yaourt"; then
		packages+=(compton dropbox faba-mono-icons-git  gcalert google-chrome          )
		defaults+=("on"    "on"    "on"                 "on"    "on"                   )
		packages+=(gtk-theme-iris-dark-git lightdm-webkit-theme-bevel-git mpdnotify-git)
		defaults+=("on"                    "on"                           "on"         )
	fi

	checklist "Choose graphical software to install:" $packages $defaults

	# Process user choices
	for choice in $choices; do
		choice=${packages[$choice]} # Get the name of the choice
		program_box "$pkg_mgr --noconfirm -S $choice" "Installing ${choice}..."
	done
fi

########################################
# Linux Software Configs
########################################

configs=( compton mpdnotify tint2 xfce4-terminal xmonad xprofile)
default=( "on"    "on"      "off" "on"           "on"   "on"    )
source_prefix="linux"

# Process user choices
for choice in $choices; do
	case $choice in
	compton)
		infobox "Linking compton files"

		declare -A compton_files
		compton_files['compton.conf']='.compton.conf'
		set_home_files_from_array compton_files
		;;
	mdpnotify)
		infobox "Linking mpdnotify files"

		ensure_dir_exists ~/.config/mpdnotify

		declare -A mpdnotify_files
		mpdnotify_files['config/mpdnotify/config']='.config/mpdnotify/config'
		mpdnotify_files['config/mpdnotify/nocover.png']='.config/mpdnotify/nocover.png'
		set_home_files_from_array mpdnotify_files
		;;
	tint2)
		infobox "Linking tint2 config"

		ensure_dir_exists ~/.config/tint2

		declare -A tint2_files
		tint2_files['config/tint2/default.tint2rc']='.config/tint2/tint2rc'
		set_home_files_from_array tint2_files
		;;
	xfce4-terminal)
		infobox "Linking XFCE Terminal config"

		ensure_dir_exists ~/.config/xfce4/terminal

		declare -A xfce_terminal_files
		xfce_terminal_files['config/xfce4/terminal/accels.scm']='.config/xfce4/terminal/accels.scm'
		xfce_terminal_files['config/xfce4/terminal/terminalrc']='.config/xfce4/terminal/terminalrc'
		set_home_files_from_array xfce_terminal_files
		;;
	xmonad)
		infobox "Linking Xmonad config"

		ensure_dir_exists ~/.xmonad

		declare -A xmonad_files
		xmonad_files['xmonad/xmonad.hs']='.xmonad/xmonad.hs'
		set_home_files_from_array xmonad_files
		;;
	xprofile)
		infobox "Linking xprofile config"

		declare -A xprofile_files
		xprofile_files['xprofile']='.xprofile'
		set_home_files_from_array xprofile_files
		;;
	esac
done



infobox "Done. Enjoy your system!"
