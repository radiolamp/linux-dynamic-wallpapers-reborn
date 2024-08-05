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
	local repo_url="https://github.com/Chillsmeit/linux-dynamic-wallpapers.git"
	local tmp_dir="/tmp/linux-dynamic-wallpapers"

	echo
	if [[ -d $wp_dir ]]; then 
		echo "Previous installation found!"; echo
		if confirm "Do you want to remove the previous installation?"; then
			echo; echo "Cleaning up your previous installation..."
			sudo rm -r $wp_dir
			echo "Done "
		else
			echo; echo "Exiting script..."
			exit 0
		fi
	else
		if confirm "Do you want to install all the available wallpapers?"; then
			echo; echo "Downloading files..."; echo "This might take a while!"; echo
			sudo rm -rf $tmp_dir
			git clone $repo_url $tmp_dir
			echo; echo "Files downloaded "; echo; echo "Installing wallpapers..."; echo
			sudo mkdir -p /usr/share/backgrounds/ /usr/share/gnome-background-properties/
			sudo cp -r $tmp_dir/dynamic-wallpapers $wp_dir
			sudo cp $tmp_dir/xml/* /usr/share/gnome-background-properties/
			sudo rm -rf $tmp_dir
			echo "Wallpapers installed. Now don't forget to set them as your desktop background!"
		else
			echo "Exiting script..."
		fi
	fi
	exit 0
}

check_install
