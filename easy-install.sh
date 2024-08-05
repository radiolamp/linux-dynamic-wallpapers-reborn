#!/bin/bash
cd ~
echo "Downloading needed files started"
git clone https://github.com/Chillsmeit/linux-dynamic-wallpapers.git  
cd linux-dynamic-wallpapers
echo "Files downloaded"

if [[ -d /usr/share/backgrounds/dynamic-wallpapers ]]
then 
	sudo rm -r /usr/share/backgrounds/dynamic-wallpapers
	echo "Setting up"
fi

echo "Installing wallpapers..."
sudo cp -r ./dynamic-wallpapers/ /usr/share/backgrounds/
sudo cp ./xml/* /usr/share/gnome-background-properties/
echo "Dynamic Wallpapers has been installed!"
cd ~ 
echo "Deleting files used only for the installation process"
sudo rm -r linux-dynamic-wallpapers
echo "    |"
echo "    '---> Deleted unneeded files!"
echo "Now, don't forget to set your preferred dynamic wallpaper from Settings!"
