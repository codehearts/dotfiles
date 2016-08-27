#!/usr/bin/env bash

# Determine which directory this script is in
general_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
. "$general_dir/utility.sh"

########################################
# General Software Configs
########################################

configs=( git  vim  screen tmux  mpd   ncmpcpp "mutt theme" "mutt sample configs")
default=( "on" "on" "on"   "off" "off" "off"   "off"        "off"                )
configs+=("msmtp sample config" "offlineimap sample config"                      )
default+=("off"                 "off"                                            )

checklist "Choose config files to set up:" configs[@] default[@]

# Process user choices
for choice in $choices; do
	choice=${configs[$choice]} # Get the name of the choice
	case $choice in
	git)
		infobox "Linking git files"

		declare -A git_files
		git_files['gitignore']='.gitignore'
		set_home_files_from_array git_files
		git config --global core.excludesfile ~/.gitignore
		git config --global core.editor $(which vim)

		get_input "Enter your name for Git:"
		git config --global user.name "$user_input"

		get_input "Enter your email address for Git:"
		git config --global user.email "$user_input"
		;;
	vim)
		infobox "Linking vim files"

		ensure_dir_exists ~/.vim

		declare -A vim_files
		vim_files['vimrc']='.vimrc'
		vim_files['vim/autoload']='.vim/autoload'
		vim_files['vim/bundle']='.vim/bundle'
		vim_files['vim/colors']='.vim/colors'
		vim_files['vim/after']='.vim/after'
		set_home_files_from_array vim_files
		;;
	screen)
		infobox "Linking screen config"

		declare -A screen_files
		screen_files['screenrc']='.screenrc'
		set_home_files_from_array screen_files
		;;
	tmux)
		infobox "Linking tmux config"

		declare -A tmux_files
		tmux_files['tmux.conf']='.tmux.conf'
		set_home_files_from_array tmux_files
		;;
	mpd)
		infobox "Linking mpd config"

		ensure_dir_exists ~/.mpd/playlists
		ensure_dir_exists ~/.mpd/tmp
		touch ~/.mpd/{database,log,pid,state}

		declare -A mpd_files
		mpd_files['mpd.conf']='.mpd/mpd.conf'
		set_home_files_from_array mpd_files
		;;
	ncmpcpp)
		infobox "Linking ncmpcpp config"

		ensure_dir_exists ~/.ncmpcpp

		declare -A ncmpcpp_files
		ncmpcpp_files['ncmpcpp/config']='.ncmpcpp/config'
		ncmpcpp_files['ncmpcpp/keys']='.ncmpcpp/keys'
		set_home_files_from_array ncmpcpp_files
		;;
	"mutt theme")
		infobox "Linking mutt theme"

		ensure_dir_exists ~/.mutt

		declare -A mutt_theme_files
		mutt_theme_files['mutt/loveless-theme']='.mutt/loveless-theme'
		set_home_files_from_array mutt_theme_files
		;;
	"mutt sample configs")
		infobox "Copying mutt sample configs"

		ensure_dir_exists ~/.mutt
		ensure_dir_exists ~/.mutt/temp
		ensure_file_exists ~/.mutt/aliases

		declare -A mutt_sample_files
		mutt_sample_files['muttrc-sample']='.muttrc-sample'
		mutt_sample_files['mutt/custom_config']='.mutt/custom_config'
		mutt_sample_files['mutt/gmail_config']='.mutt/gmail_config'
		mutt_sample_files['mutt/school_config']='.mutt/school_config'
		mutt_sample_files['mutt/mailcap-sample']='.mutt/mailcap-sample'
		set_home_files_from_array mutt_sample_files $action_copy

		declare -A mutt_script_files
		mutt_script_files['mutt/add_sender_to_aliases.sh']='.mutt/add_sender_to_aliases.sh'
		set_home_files_from_array mutt_script_files
		;;
	"msmtp sample config")
		infobox "Copying msmtp sample config"

		ensure_dir_exists ~/.msmtp

		declare -A msmtp_sample_files
		msmtp_sample_files['msmtprc-sample']='.msmtprc-sample'
		set_home_files_from_array msmtp_sample_files $action_copy

		declare -A msmtp_files
		msmtp_files['msmtp/msmtp-gnome-tool.py']='.msmtp/msmtp-gnome-tool.py'
		set_home_files_from_array msmtp_files
		;;
	"offlineimap sample config")
		infobox "Copying offlineimap sample config"

		declare -A offlineimap_sample_files
		offlineimap_sample_files['offlineimaprc-sample']='.offlineimaprc-sample'
		set_home_files_from_array offlineimap_sample_files $action_copy

		declare -A offlineimap_files
		offlineimap_files['offlineimap.py']='.offlineimap.py'
		set_home_files_from_array offlineimap_files
		;;
	esac
done

########################################
# Git Submodules
########################################

is_command_installed git
if $installed; then
	yes_no "Update Git submodules (Vim bundles, etc.)?"
	if $yes; then
		program_box "git submodule init" "Initializing Git submodules"
		program_box "git submodule update" "Updating Git submodules"
		program_box "git submodule foreach git pull origin master" "Pulling Git submodules"
	fi
fi

# Check if a post_setup function was declared
is_bash_function post_setup
if $is_function; then
	post_setup
else
	infobox "Setup complete!"
fi
