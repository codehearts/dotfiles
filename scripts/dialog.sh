#!/bin/bash

# Prevent evaluating this file multiple times
dialog_included=${dialog_included:-false}
if ! $dialog_included; then
	


# Determine which dialog software to use
read dialog <<< "$(which whiptail dialog 2> /dev/null)"

# Displays an infobox with $1 as the contents.
# $1: The contents of the infobox
infobox () {
	$dialog --infobox "$1" 12 50
}

# Displays a programbox with $2 as the text.
# $1: The command to run in the programbox
# $2: The text label
program_box () {
	infobox "$2"
	$1
}

# Displays an input field with $1 as the label
# $1: The label for the input field
# Sets $user_input to the user’s input
get_input () {
	$dialog --inputbox "$1" 12 50 2> /tmp/userinput
	user_input=`cat /tmp/userinput`
}

# Displays a yes/no question with $1 as the prompt
# $1: The question prompt
# Returns 0 for "yes" and 1 for "no"
yes_no () {
	$DIALOG --yesno "$1" 12 50
	result=$?; yes=false; [ $result -eq 0 ] && yes=true
}

# Displays a checklist with the given options.
# $1: The text to display above the checklist
# $2: The options to display in the checklist
# $3: Defaults for the options, as an array of "on"/"off"
# Sets $choices to a string of the users' choices, one per line
checklist () {
	declare -a option_arg=("${!2}")
	declare -a default_arg=("${!3}")

	i=0
	options=()
	for option in "${option_arg[@]}"; do
		options+=($i $package "${default_arg[$i]}")
		i=$[i+1]
	done

	checklist=($dialog --separate-output --no-tags --checklist "$1" 22 50 $i)
	choices=$("${checklist[@]}" "${options[@]}" 2>&1 >/dev/tty)
}



fi
dialog_included=true
