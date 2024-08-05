#!/bin/bash

confirm() {
	local prompt="$1"
	local answer

	while true; do
		echo "$prompt"
		read -p "Enter your choice (y/n): " answer
		case "${answer,,}" in
			y|yes) return 0 ;;
			n|no) return 1 ;;
			*) echo "Invalid choice, please enter 'y' or 'n'"; echo " " ;;
		esac
	done
}

check_install() {
	local wp_dir="/usr/share/backgrounds/dynamic-wallpapers"

	echo
	if [[ -d $wp_dir ]]; then 
		echo "Previous installation found!"; echo
		if confirm "Do you want to remove the previous installation?"; then
			echo; echo "Cleaning up your previous installation..."
			sudo rm -r $wp_dir
			echo "Done "
		else
			echo; echo "Exiting script..."
		fi
	else
		if confirm "Do you want to install all the available wallpapers?"; then
			echo "Installing wallpapers..."
			sudo mkdir -p /usr/share/backgrounds/ /usr/share/gnome-background-properties/
			sudo cp -r "$(pwd)/dynamic-wallpapers" $wp_dir
			sudo cp "$(pwd)/xml/"* /usr/share/gnome-background-properties/
			echo "Wallpapers have been installed. Enjoy setting them as your desktop background!"
		else
			echo "Exiting script..."
		fi
	fi
	exit 0
}

check_install

