#!/usr/bin/env bash

# Determine which directory this script is in
setup_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

while test $# -gt 0; do
	case "$1" in
		-h|--help)
			echo "$package - Sets up a system from my preferences."
			echo ""
			echo "$package [options]"
			echo ""
			echo "Options:"
			echo "-h"
			echo "--help"
			echo "    show this help message"
			echo "--mac                     "
			echo "--osx"
			echo "    setup symlinks for a Mac system"
			echo "--arch"
			echo "    setup symlinks for an Arch Linux system"
			exit 0
			;;
		--mac|--osx)
			shift
			. "$setup_dir/osx/osx-setup.sh"
			shift
			;;
		--arch)
			shift
			. "$setup_dir/linux/arch-setup.sh"
			shift
			;;
		*)
			break
			;;
	esac
done

# Include the dialog and file tools script
. "$setup_dir/scripts/dialog.sh"
. "$setup_dir/scripts/file_tools.sh"
source_prefix="general"

. "$setup_dir/scripts/general-setup.sh"

exit 0
