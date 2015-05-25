#!/bin/bash

# Prevent evaluating this file multiple times
file_tools_included=${file_tools_included:-false}
if ! $file_tools_included; then



action_copy=1
action_symlink=2

# Ensures that the given directory exists
# $1: The path to the directory
ensure_dir_exists () {
	if [[ ! -d "$1" ]]; then
		mkdir -p "$1"
	fi
}

# Moves a collection of iles onto the system in the user's home directory using symlinks.
# $source_prefix can be set to define a subdir where the source files reside.
# $1: An associative array in the form array[$source] = $dest
# $2: An optional code for whether to copy or symlink (default is symlink)
set_home_files_from_array () {
	# Get the associative array definition and evaluate it into $files
	tmp="$( declare -p ${1} )"; eval "declare -A files=${tmp#*=}"
	for i in "${!files[@]}"; do
		set_file "$PWD/$source_prefix/$i" "$HOME/${files[$i]}" "$2"
	done
}

# Moves a collection of dotfiles onto the system using symlinks.
# $1: An associative array in the form array[$source] = $dest
# $2: An optional code for whether to copy or symlink (default is symlink)
set_files_from_array () {
	# Get the associative array definition and evaluate it into $files
	tmp="$( declare -p ${1} )"; eval "declare -A files=${tmp#*=}"
	for i in "${!files[@]}"; do
		set_file "$i" "${files[$i]}" "$2"
	done
}

# Moves a dotfile from $1 to $2 on the system using symlinks or by copying.
# The default is to use symlinks unless $action_copy is passed.
# $1: The location of the dotfile in this repo
# $2: Where to place the dotfile on the system
# $3: An optional code for whether to copy or symlink
set_file () {
	src="$1"
	dest="$2"
	dontmove=0
	
	# If the destination file already exists
	if [ -e "$dest" ]; then
		$dialog --yesno "$dest already exists on this system. Overwrite it?" 8 76
		choice=$?

		if [ $choice -eq 0 ]; then
			rm "$dest"
		else
			dontmove=1
		fi
	fi

	if [ $dontmove -eq 0 ]; then
		if [[ -z "$3" ]] || [[ $3 == $action_symlink ]]; then
			# Using -f because the file is already known to not exist,
			# even if a symlink exists in that location to a nonexistent file
			ln -sf "$src" "$dest"
		elif [[ $3 == $action_copy ]]; then
			cp -r "$src" "$dest"
		fi
	fi
}



fi
file_tools_included=true
