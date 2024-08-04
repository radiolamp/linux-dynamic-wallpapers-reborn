#!/bin/bash
if [[ -d /usr/share/backgrounds/dynamic-wallpapers ]]
then 
	sudo rm -r /usr/share/backgrounds/dynamic-wallpapers
	echo "Cleaning up"
fi

echo "Installing wallpapers..."
sudo mkdir -p /usr/share/backgrounds/
sudo mkdir -p /usr/share/gnome-background-properties/ 
sudo cp -r $(pwd)/dynamic-wallpapers /usr/share/backgrounds/dynamic-wallpapers
sudo cp $(pwd)/xml/* /usr/share/gnome-background-properties/
echo "Wallpapers has been installed. Enjoy setting them as your desktop background!"
