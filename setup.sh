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

ln -s $PWD/gitignore ~/.gitignore
ln -s $PWD/vimrc ~/.vimrc
ln -s $PWD/vim/bundle ~/.vim/bundle
ln -s $PWD/vim/color ~/.vim/color

# TODO Arch system symlinks
