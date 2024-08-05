#!/bin/bash

confirm() {
	local prompt="$1"
	local answer

	while true; do
		echo "$prompt"
		read -p "Enter your choice (y/n): " answer
		case "$answer" in
			[Yy]|[Yy][Ee][Ss])
				return 0
				;;
			[Nn]|[Nn][Oo])
				return 1
				;;
			*)
				echo "Invalid choice, please enter 'y' or 'n'"
				echo ""
				;;
		esac
	done
}

check_install(){
	if [[ -d /usr/share/backgrounds/dynamic-wallpapers ]]; then 
		echo "Previous installation found!"
		if confirm "Do you want to remove the previous installation?"; then
			echo "Cleaning up..."
			sudo rm -r /usr/share/backgrounds/dynamic-wallpapers
			echo "Done "
			exit 0
		else
			echo "Exiting script..."
			exit 0
		fi
	else
		if confirm "Do you want to install all the available wallpapers?"; then
			echo "Installing wallpapers..."
			sudo mkdir -p /usr/share/backgrounds/
			sudo mkdir -p /usr/share/gnome-background-properties/
			sudo cp -r "$(pwd)/dynamic-wallpapers" /usr/share/backgrounds/dynamic-wallpapers
			sudo cp "$(pwd)/xml/"* /usr/share/gnome-background-properties/
			echo "Wallpapers have been installed. Enjoy setting them as your desktop background!"
			exit 0
		else
			echo "Exiting script..."
			exit 0
		fi
	fi
}

check_install
