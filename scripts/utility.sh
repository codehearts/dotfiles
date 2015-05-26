#!/bin/bash

# Prevent evaluating this file multiple times
utility_included=${utility_included:-false}
if ! $utility_included; then
	


# Determines if the given command is installed
# $1: The name of the command to check for
# Sets $installed to true if it is
is_command_installed () {
	installed=true
	if ! cmd_loc="$(type -p "$1")" || [ -z "$cmd_loc" ]; then
		installed=false
	fi
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



fi
utility_included=true
