#!/bin/bash

SYSTEM="none"
read DIALOG <<< "$(which whiptail dialog 2> /dev/null)"

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

ACTION_COPY=1
ACTION_SYMLINK=2

# Ensures that the given directory exists
# $1: The path to the directory
ensure_dir_exists () {
	if [[ ! -d "$1" ]]; then
		mkdir -p "$1"
	fi
}

# Moves a collection of iles onto the system in the user's home directory using symlinks.
# $1: An associative array in the form array[$source] = $dest
# $2: An optional code for whether to copy or symlink (default is symlink)
set_home_files_from_array () {
	# Get the associative array definition and evaluate it into $files
	tmp="$( declare -p ${1} )"; eval "declare -A files=${tmp#*=}"
	for i in "${!files[@]}"; do
		set_file "$PWD/$i" "$HOME/${files[$i]}" "$2"
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
# The default is to use symlinks unless $ACTION_COPY is passed.
# $1: The location of the dotfile in this repo
# $2: Where to place the dotfile on the system
# $3: An optional code for whether to copy or symlink
set_file () {
	src="$1"
	dest="$2"
	dontmove=0
	
	# If the destination file already exists
	if [ -e "$dest" ]; then
		$DIALOG --yesno "$dest already exists on this system. Overwrite it?" 8 76
		choice=$?

		if [ $choice -eq 0 ]; then
			rm "$dest"
		else
			dontmove=1
		fi
	fi

	if [ $dontmove -eq 0 ]; then
		if [[ -z "$3" ]] || [[ $3 == $ACTION_SYMLINK ]]; then
			# Using -f because the file is already known to not exist,
			# even if a symlink exists in that location to a nonexistent file
			ln -sf "$src" "$dest"
		elif [[ $3 == $ACTION_COPY ]]; then
			cp -r "$src" "$dest"
		fi
	fi
}

# Displays an infobox with $1 as the contents.
# $1: The contents of the infobox
infobox () {
	$DIALOG --infobox "$1" 12 50
}

GIT=10;VIM=20;SCREEN=30;TMUX=40;MPD=50;NCMPCPP=60;MUTT_THEME=70;MUTT_SAMPLE=80;MSMTP=90;OFFLINEIMAP=100;
cmd=($DIALOG --separate-output --no-tags --checklist "Choose config files to set up:" 22 50 16)
options=(
	$GIT         "git"                        on
	$VIM         "vim"                        on
	$SCREEN      "screen"                     on
	$TMUX        "tmux"                       off
	$MPD         "mpd"                        off
	$NCMPCPP     "ncmpcpp"                    off
	$MUTT_THEME  "mutt theme"                 off
	$MUTT_SAMPLE "mutt sample configs"        off
	$MSMTP       "msmtp sample config"        off
	$OFFLINEIMAP "offlineimap sample config"  off
)
# TODO Linux-specific settings with compton, tint2, netctl, conky, xinitrc, xmonad, mpdnotify, bash-completion on Arch
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
		infobox "Linking git files"

		declare -A git_files
		git_files['gitignore']='.gitignore'
		set_home_files_from_array git_files
		git config --global core.excludesfile ~/.gitignore
		;;
	$VIM)
		infobox "Linking vim files"

		ensure_dir_exists ~/.vim

		declare -A vim_files
		vim_files['vimrc']='.vimrc'
		vim_files['vim/bundle']='.vim/bundle'
		vim_files['vim/colors']='.vim/colors'
		vim_files['vim/after']='.vim/after'
		set_home_files_from_array vim_files
		;;
	$SCREEN)
		infobox "Linking screen config"

		declare -A screen_files
		screen_files['screenrc']='.screenrc'
		set_home_files_from_array screen_files
		;;
	$TMUX)
		infobox "Linking tmux config"

		declare -A tmux_files
		tmux_files['tmux.conf']='.tmux.conf'
		set_home_files_from_array tmux_files
		;;
	$MPD)
		infobox "Linking mpd config"

		ensure_dir_exists ~/.mpd/playlists
		ensure_dir_exists ~/.mpd/tmp
		touch ~/.mpd/{database,log,pid,state}

		declare -A mpd_files
		mpd_files['mpd.conf']='.mpd/mpd.conf'
		set_home_files_from_array mpd_files
		;;
	$NCMPCPP)
		infobox "Linking ncmpcpp config"

		ensure_dir_exists ~/.ncmpcpp

		declare -A ncmpcpp_files
		ncmpcpp_files['ncmpcpp/config']='.ncmpcpp/config'
		ncmpcpp_files['ncmpcpp/keys']='.ncmpcpp/keys'
		set_home_files_from_array ncmpcpp_files
		;;
	$MUTT_THEME)
		infobox "Linking mutt theme"

		ensure_dir_exists ~/.mutt

		declare -A mutt_theme_files
		mutt_theme_files['mutt/loveless-theme']='.mutt/loveless-theme'
		set_home_files_from_array mutt_theme_files
		;;
	$MUTT_SAMPLE)
		infobox "Copying mutt sample configs"

		ensure_dir_exists ~/.mutt

		declare -A mutt_sample_files
		mutt_sample_files['muttrc-sample']='.muttrc-sample'
		mutt_sample_files['mutt/custom_config']='.mutt/custom_config'
		mutt_sample_files['mutt/gmail_config']='.mutt/gmail_config'
		mutt_sample_files['mutt/school_config']='.mutt/school_config'
		mutt_sample_files['mutt/mailcap-sample']='.mutt/mailcap-sample'
		set_home_files_from_array mutt_sample_files $ACTION_COPY
		;;
	$MSMTP)
		infobox "Copying msmtp sample config"

		ensure_dir_exists ~/.msmtp

		declare -A msmtp_sample_files
		msmtp_sample_files['msmtprc-sample']='.msmtprc-sample'
		set_home_files_from_array msmtp_sample_files $ACTION_COPY

		declare -A msmtp_files
		msmtp_files['msmtp/msmtp-gnome-tool.py']='.msmtp/msmtp-gnome-tool.py'
		set_home_files_from_array msmtp_files
		;;
	$MSMTP)
		infobox "Copying offlineimap sample config"

		declare -A offlineimap_sample_files
		offlineimap_sample_files['offlineimaprc-sample']='offlineimaprc-sample'
		set_home_files_from_array offlineimap_sample_files $ACTION_COPY

		declare -A offlineimap_files
		offlineimap_files['offlineimap.py']='.offlineimap.py'
		set_home_files_from_array offlineimap_files
		;;
	esac
done

infobox "Initializing Git submodules"
git submodule init &> /dev/null # Silence output
git submodule update &> /dev/null # Silence output
git submodule foreach git pull origin master &> /dev/null # Silence output

infobox "Setup complete!"
echo

exit 0
