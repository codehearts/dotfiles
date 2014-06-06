#!/bin/bash

SYSTEM="none"

while test $# -gt 0; do
	case "$1" in
		-h|--help)
			echo "$package - Symlinks dotfiles into place"
			echo " "
			echo "$package [options]"
			echo " "
			echo "options:"
			echo "-h, --help                show brief help"
			echo "--mac                     setup symlinks for a Mac system"
			echo "--arch                    setup symlinks for an Arch Linux system"
			exit 0
			;;
		--mac)
			shift
			SYSTEM="mac"
			shift
			;;
		--arch)
			shift
			SYSTEM="arch"
			shift
			;;
		*)
			break
			;;
	esac
done

# Ensures that the given directory exists
# $1: The path to the directory
ensure_dir_exists () {
	if [[ ! -d "$1" ]]; then
		mkdir -p "$1"
	fi
}

# Moves a collection of iles onto the system in the user's home directory using symlinks.
# $1: An associative array in the form array[$source] = $dest
set_home_files_from_array () {
	# Get the associative array definition and evaluate it into $files
	tmp="$( declare -p ${1} )"; eval "declare -A files=${tmp#*=}"
	for i in "${!files[@]}"; do
		set_file "$PWD/$i" "$HOME/${files[$i]}"
	done
}

# Moves a collection of dotfiles onto the system using symlinks.
# $1: An associative array in the form array[$source] = $dest
set_files_from_array () {
	# Get the associative array definition and evaluate it into $files
	tmp="$( declare -p ${1} )"; eval "declare -A files=${tmp#*=}"
	for i in "${!files[@]}"; do
		set_file "$i" "${files[$i]}"
	done
}

# Moves a dotfile from $1 to $2 on the system using symlinks.
# $1: The location of the dotfile in this repo
# $2: Where to place the dotfile on the system
set_file () {
	src="$1"
	dest="$2"
	dontmove=0
	
	# If the destination file already exists
	if [ -e "$dest" ]; then
		dialog --yesno "$dest already exists on this system. Overwrite it?" 8 76
		choice=$?

		if [ $choice -eq 0 ]; then
			rm "$dest"
		else
			dontmove=1
		fi
	fi

	if [ $dontmove -eq 0 ]; then
		# Using -f because the file is already known to not exist,
		# even if a symlink exists in that location to a nonexistent file
		ln -sf "$src" "$dest"
	fi
}

# Displays an infobox with $1 as the contents.
# $1: The contents of the infobox
infobox () {
	dialog --infobox "$1" 22 76
}

cmd=(dialog --separate-output --checklist "Dotfiles to link into place:" 22 76 16)
# TODO Add mutt, msmtp, offlineimap
GIT=10;VIM=20;TMUX=30;MPD=40;NCMPCPP=50;URLVIEW=80;VIMPERATOR=90
options=(
	$GIT        "Git"        on
	$VIM        "Vim"        on
	$TMUX       "tmux"       off
	$MPD        "mpd"        off
	$NCMPCPP    "ncmpcpp"    off
	$URLVIEW    "urlview"    off
	$VIMPERATOR "Vimperator" off
)
# TODO Linux-specific settings with compton, tint2, netctl, conky, xinitrc, xmonad
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

# If the user cancelled, exit
if [[ -z "$choices" ]]; then
	clear
	exit 0
fi

# Process user choices
for choice in $choices; do
	case $choice in
	$GIT)
		infobox "Linking Git files"

		declare -A git_files
		git_files['gitignore']='.gitignore'
		set_home_files_from_array git_files
		;;
	$VIM)
		infobox "Linking Vim files"

		ensure_dir_exists ~/.vim

		declare -A vim_files
		vim_files['vimrc']='.vimrc'
		vim_files['vim/bundle']='.vim/bundle'
		vim_files['vim/colors']='.vim/colors'
		set_home_files_from_array vim_files
		;;
	$TMUX)
		infobox "Linking tmux files"

		declare -A tmux_files
		tmux_files['tmux.conf']='.tmux.conf'
		set_home_files_from_array tmux_files
		;;
	$MPD)
		infobox "Linking mpd files"

		ensure_dir_exists ~/.mpd/playlists
		ensure_dir_exists ~/.mpd/tmp
		touch ~/.mpd/{database,log,pid,state}

		declare -A mpd_files
		mpd_files['mpd.conf']='.mpd/mpd.conf'
		set_home_files_from_array mpd_files
		;;
	$NCMPCPP)
		infobox "Linking ncmpcpp files"

		ensure_dir_exists ~/.ncmpcpp

		declare -A ncmpcpp_files
		ncmpcpp_files['ncmpcpp/config']='.ncmpcpp/config'
		ncmpcpp_files['ncmpcpp/keys']='.ncmpcpp/keys'
		set_home_files_from_array ncmpcpp_files
		;;
	$URLVIEW)
		infobox "Linking urlview files"

		declare -A urlview_files
		urlview_files['urlview']='.urlview'
		set_home_files_from_array urlview_files
		;;
	$VIMPERATOR)
		infobox "Linking Vimperator files"

		ensure_dir_exists ~/.vimperator

		declare -A vimperator_files
		vimperator_files['vimperatorrc']='.vimperatorrc'
		vimperator_files['vimperator/colors']='.vimperator/colors'
		set_home_files_from_array vimperator_files
		;;
	esac
done

infobox "Initializing Git submodules"
git submodule init
git submodule update
clear

exit 0
