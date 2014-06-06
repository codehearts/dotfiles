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
		ln -s "$src" "$dest"
	fi
}

# Displays an infobox with $1 as the contents.
# $1: The contents of the infobox
infobox () {
	dialog --infobox "$1" 22 76
}

cmd=(dialog --separate-output --checklist "Dotfiles to link into place:" 22 76 16)
options=(
	1 "Git" on
	2 "Vim" on
)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear

# If the user cancelled, exit
if [[ -z "$choices" ]]; then
	exit 0
fi

# Process user choices
for choice in $choices; do
	case $choice in
	1) # Git
		infobox "Linking Git files"

		declare -A git_files
		git_files['gitignore']='.gitignore'
		set_home_files_from_array git_files

		clear
		;;
	2) # Vim
		infobox "Linking Vim files"

		# Ensure ~/.vim exists
		if [[ ! -d ~/.vim ]]; then
			mkdir ~/.vim
		fi

		declare -A vim_files
		vim_files['vimrc']='.vimrc'
		vim_files['vim/bundle']='.vim/bundle'
		vim_files['vim/colors']='.vim/colors'
		set_home_files_from_array vim_files

		clear
		;;
	esac
done

infobox "Initializing Git submodules"
git submodule init
git submodule update
clear

exit 0
