#!/bin/bash

# Prevent evaluating this file multiple times
utility_included=${utility_included:-false}
if ! $utility_included; then
	


# Determines if the given command is installed
# $1: The name of the command to check for
# Sets $installed to true if it is
is_command_installed () {
	installed=true
	if ! cmd_loc="$(type -p $1)" || [ -z "$cmd_loc" ]; then
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

# Uncomments the lines in the given string in the given output file
# If a line is already uncommented in the file, nothing will be done
# $1: The lines to uncomment
# $2: The file to uncomment in
# $3: The comment delimeter. Currently only supports character at the beginning of a line
uncomment_line_in_file () {
	contents=$(cat "$2")

	# Process each line in the input string
	while read -r line; do
		# This regex searches for the line with a comment symbol
		if [[ -n $(echo "$contents" | perl -pe "m|(^[\s]*[\Q$3\E]?[\s]*\Q$1\E[\s]*$)| and print \$1") ]]; then
			# If the line was found commented
			# This regex finds a version of the line with the comment symbol
			# and removes the comment symbol
			contents=$(cat "$2" | perl -pe "s{(^[\s]*)(\Q$3\E)([\s]*\Q$1\E[\s]*$)}{\$1\$3}i")
		fi
	done <<< "$1"

	# Replace the file with the new contents
	sudo sh -c "echo \"$contents\" > $2"
}

# Replaces the given term in the file
# $1: The old term to replace
# $2: The new term to replace it with
# $3: The file to replace in
replace_term_in_file () {
	sudo sed -i -e "s/$1/$2/g" $3
}



fi
utility_included=true
