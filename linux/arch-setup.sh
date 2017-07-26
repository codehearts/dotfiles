#!/usr/bin/env bash

# Configures Arch Linux to the way I like it.
# This is entirely my own taste, but may be useful for
# other people who are interested in automating their own setup.

########################################
# Initial Setup
########################################

# Determine which directory this script is in
linux_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Include the utility script
. "$linux_dir/../scripts/utility.sh"

# Set our package manager command
pkg_mgr="sudo pacman"
is_command_installed yaourt
if $installed; then pkg_mgr=yaourt; fi

# List of packages to install
to_install=()

# Determines if the given package is installed
# $1: The name of the package to check for
# Sets $installed to true if it is
is_package_installed () {
	installed=true
	if [ -z "$($pkg_mgr -Qi $1 2>/dev/null)" ]; then
		installed=false
	fi
}

# Marks a given package for installation
# If the package is already installed, it will not be marked.
# $1: The name of the package
mark_for_installation () {
	to_install+=("$1")
}

########################################
# System Updates
########################################

$pkg_mgr -Syyu

########################################
# Dialog Software Install
########################################

is_command_installed whiptail
if ! $installed; then mark_for_installation libnewt; fi

is_command_installed ntpd
if ! $installed; then mark_for_installation ntp; fi

is_command_installed git
if ! $installed; then mark_for_installation git; fi

# Install any missing prereqs
if [ ${#to_install[@]} -ne 0 ]; then
	$pkg_mgr --needed -S ${to_install[@]} >/dev/tty
fi

# Reset the list of packages to install
to_install=()

# Include the dialog script
. "$linux_dir/../scripts/dialog.sh"
. "$linux_dir/../scripts/file_tools.sh"
source_prefix="linux"

########################################
# Yaourt
########################################

is_command_installed yaourt
if ! $installed; then
	yes_no "Install yaourt?"
	if $yes; then
		$pkg_mgr --noconfirm -S base-devel
		git clone https://aur.archlinux.org/package-query.git
		cd package-query
		makepkg -si
		cd ..
		git clone https://aur.archlinux.org/yaourt.git
		cd yaourt
		makepkg -si
		cd ..
		rm -rf yaourt* package-query*

		pkg_mgr=yaourt
	fi
fi

########################################
# CLI Software
########################################

packages=( alsa-lib alsa-utils bash-completion calc ctags dictd       )
defaults=( "on"     "on"       "on"            "on" "on"  "on"        )
packages+=(gnome-keyring  htop mpd  msmtp mutt  ncmpcpp offlineimap   )
defaults+=("on"           "on" "on" "on"  "off" "on"    "on"          )
packages+=(openssh pulseaudio-alsa python-pip python2-keyring python2-gnomekeyring )
defaults+=("on"    "on"            "on"       "on"            "on"                 )
packages+=(python2-pip rfkill rsync texlive-core texlive-humanities   )
defaults+=("on"        "on"   "on"  "on"         "on"                 )
packages+=(texlive-pictures tmux unzip wpa_actiond                    )
defaults+=("on"             "on" "on"  "on"                           )

# Add yaourt packages if yaourt was installed
if [ "$pkg_mgr" == "yaourt" ]; then
	packages+=(gcalcli mutt-sidebar pkgbuild-introspection-git urlview)
	defaults+=("on"    "on"         "on"                       "on"   )
fi

checklist "Choose software to install:" packages[@] defaults[@]

# Process user choices
for choice in $choices; do
	choice=${packages[$choice]} # Get the name of the choice
	mark_for_installation $choice

	case $choice in
	python2-keyring)
		# Install support for alternate keyrings
		mark_for_installation python2-keyrings-alt
	;;
	esac
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
	mark_for_installation xorg-server
	mark_for_installation xorg-xrdb
	mark_for_installation xorg-xbacklight
	mark_for_installation xorg-xinit
	mark_for_installation xorg-xdpyinfo
	mark_for_installation xdotool
	mark_for_installation xf86-input-libinput

	########################################
	# Graphical Software
	########################################

	packages=( accountsservice adobe-source-sans-pro-fonts bspwm chromium       )
	defaults=( "on"            "on"                        "on"  "off"          )
	packages+=(compton dmenu dunst feh  firefox gvim lemonbar-xft-git           )
	defaults+=("on"    "on"  "on"  "on" "on"    "on" "on"                       )
	packages+=(lightdm-gtk-greeter rdesktop rxvt-unicode scrot sxhkd slock      )
	defaults+=("off"               "off"    "on"         "on"  "on"  "off"      )
	packages+=(tigervnc vagrant virtualbox zathura-pdf-mupdf                    )
	defaults+=("on"     "on"    "on"       "on"                                 )

	# Add yaourt packages if yaourt was installed
	if [ "$pkg_mgr" == "yaourt" ]; then
		packages+=(dropbox numix-circle-icon-theme-git  gcalert google-chrome   )
		defaults+=("on"    "on"                         "on"    "off"           )
		packages+=(gtk-theme-iris-dark-git lightdm-webkit-theme-tendou          )
		defaults+=("on"                    "on"                                 )
		packages+=(mpd-notification-git otf-meslo-powerline-git ttf-mplus       )
		defaults+=("on"                 "on"                    "on"            )
		defaults+=(xdo-git                                                      )
		defaults+=("on"                                                         )
	fi

	checklist "Choose graphical software to install:" packages[@] defaults[@]

	# Process user choices
	for choice in $choices; do
		choice=${packages[$choice]} # Get the name of the choice
		mark_for_installation $choice
	done
fi

########################################
# Package Installation
########################################

if [ "${#to_install[@]}" -ne "0" ]; then
	echo "Preparing to install..."
	program_box "$($pkg_mgr --needed -S ${to_install[@]} >/dev/tty)" "Installing packages..."
fi

# Post-installation
lightdm_service=false
for installed_package in "${to_install[@]}"; do
	package=${to_install[$installed_package]} # Get the name of the package

	case $installed_package in
	feh)
		# Add feh script
		declare -A feh_script
		feh_script['fehbg']='.fehbg'
		set_home_files_from_array feh_script $action_copy
	;;
	lightdm-gtk-greeter)
		lightdm_service=true
	;;
	lightdm-webkit-theme-tendou)
		# Set up the tendou theme
		uncomment_line_in_file "greeter-session=example-gtk-gnome" /etc/lightdm/lightdm.conf '#'
		replace_term_in_file 'example-gtk-gnome' 'lightdm-webkit2-greeter' /etc/lightdm/lightdm.conf
		replace_term_in_file '#user-session=default' 'user-session=bspwm' /etc/lightdm/lightdm.conf
		replace_term_in_file 'webkit-theme=webkit' 'webkit-theme=tendou' /etc/lightdm/lightdm-webkit*.conf
		lightdm_service=true
	;;
	offlineimap)
		# Set offlineimap to run in the background
		ensure_dir_exists ~/.config/systemd/user
		declare -A offlineimap_autostart
		offlineimap_autostart['config/systemd/user/offlineimap.service']='.config/systemd/user/offlineimap.service'
		offlineimap_autostart['config/systemd/user/offlineimap.timer']='.config/systemd/user/offlineimap.timer'
		set_home_files_from_array offlineimap_autostart $action_copy

		program_box "systemctl --user daemon-reload"              "Reloading systemctl user daemons"
		program_box "systemctl --user start offlineimap.timer"    "Running offlineimap in background"
		program_box "systemctl --user start offlineimap.service"  "Running offlineimap in background"
		program_box "systemctl --user enable offlineimap.timer"   "Running offlineimap in background"
		program_box "systemctl --user enable offlineimap.service" "Running offlineimap in background"
	;;
	python-pip)
		program_box "pip install --user pyglet" "Installing Pyglet"
		program_box "pip install --user zenbu"  "Installing Zenbu"
		program_box "pip install --user colorz" "Installing colorz"

		# Set up zenbu files
		ensure_dir_exists ~/.config
		declare -A zenbu_files
		zenbu_files['config/zenbu']='.config/zenbu'
		set_home_files_from_array zenbu_files
		zenbu soft-pink
	;;
	python2-pip)
		program_box "pip2 install --user pyglet" "Installing Pyglet"
	;;
	virtualbox)
		# Enable the necessary kernel modules at boot
		sudo touch /etc/modules-load.d/virtualbox.conf
		echo 'vboxdrv' | sudo tee /etc/modules-load.d/virtualbox.conf &>/dev/null
	;;
	esac
done

########################################
# Package Cleanup
########################################

# Only do this if there are orphans to remove
if [ -n "$($pkg_mgr -Qqtd)" ]; then
	program_box "$pkg_mgr -Rns $($pkg_mgr -Qqtd)" "Cleaning orphaned packages..."
fi

########################################
# Linux Software Configs
########################################

configs=( compton gcalert locking shell-scripts xinitrc    )
default=( "on"    "on"    "on"    "on"          "on"       )

checklist "Choose Linux config files to set up:" configs[@] default[@]

# Process user choices
for choice in $choices; do
	choice=${configs[$choice]} # Get the name of the choice
	case $choice in
	compton)
		infobox "Linking compton files"

		declare -A compton_files
		compton_files['compton.conf']='.compton.conf'
		set_home_files_from_array compton_files
		;;
	gcalert)
		infobox "Linking gcalert files"

		ensure_dir_exists ~/.config/gcalert

		declare -A gcalert_files
		gcalert_files['config/gcalert/gcalertrc']='.config/gcalert/gcalertrc'
		set_home_files_from_array gcalert_files
		;;
	locking)
		declare -A lock_scripts
		lock_scripts["shell-scripts/katie_lock"]="/usr/local/sbin/katie_lock"

		program_box "$($pkg_mgr --needed -S imagemagick scrot xss-lock i3lock-lixxia-git >/dev/tty)" "Installing necessary packages..."

		sudo chown `whoami` /usr/local/sbin
		set_files_from_array lock_scripts $action_copy
		sudo chown -R root:root /usr/local/sbin
		;;
	shell-scripts)
		infobox "Copying scripts into /usr/local/sbin/"
		declare -A shell_scripts
		for script in $linux_dir/shell-scripts/*; do
			shell_scripts["shell-scripts/$(basename $script)"]="/usr/local/sbin/$(basename $script)"
		done

		program_box "$($pkg_mgr --needed -S python2-numpy python2-scipy python-imaging imagemagick scrot i3lock-lixxia-git >/dev/tty)" "Installing necessary packages..."

		sudo chown `whoami` /usr/local/sbin
		set_files_from_array shell_scripts $action_copy
		sudo chown -R root:root /usr/local/sbin
		;;
	xinitrc)
		infobox "Linking xinitrc config"

		declare -A xinitrc_files
		xinitrc_files['xinitrc']='.xinitrc'
		set_home_files_from_array xinitrc_files
		;;
	esac
done

########################################
# Post-setup Operations
########################################

post_setup () {
	if $lightdm_service; then
		if [ "$(sudo systemctl is-enabled lightdm.service)" != "enabled" ]; then
			sudo systemctl enable lightdm.service
		fi

		sudo systemctl start lightdm.service
	fi
}



infobox "Done. Enjoy your system!"
