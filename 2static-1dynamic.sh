#!/bin/bash
#this script generates a dynamic wallpaper given two static wallpapers.
#it works according to the directories of Linux_dynamic_wallpapers project.
#it generates a compressed gif and the xml files for Gnome.
#it commits the changes to the local git.
#websites used for preparing the photos:
# 																			- https://www.iloveimg.com/
#																				- https://cloudconvert.com/heic-converter
#																				- https://ezgif.com/jpg-to-gif
#																							parameters for gif on website:
#																																						- delay time: 100
#																																						- loop count: forever
#																																						- crossfade frames:
#																																						 								- fader delay:6
#																																														- frame count 10

read -p $'Insert the path of the day wallpaper: \n[full path or just file name if the file is in the same directory eg. DailyLove.jpg] \n' daywallpaper
read -p $'Insert the path of the night wallpaper: \n[full path or just file name if the file is in the same directory eg. NightlyLove.jpg] \n' nightwallpaper
read -p $'What name would like to attribute to the dynamic wallpaper? \n' dwallpapername
echo "generating the gif file..."
convert $daywallpaper $nightwallpaper -morph 10 -set delay 6 \( -clone 0 -set delay 100 \) -swap 0 +delete \( +clone   -set delay 100 \) +swap   +delete -loop 0 -duplicate 1,-2-1 $dwallpapername.gif
echo "gif file generated"
echo "compressing the gif file.."
mogrify -resize 20% $dwallpapername.gif
echo "gif file compressed"
mv $dwallpapername.gif Screenshots
#by the following 4 lines of code I'll get the extension of the wallpapers
daywallpapername=$(basename -- "$daywallpaper")
daywallpaperextension="${daywallpapername##*.}"
nightwallpapername=$(basename -- "$nightwallpaper")
nightwallpaperextension="${nightwallpapername##*.}"
mv -- "$daywallpaper" "${dwallpapername}-1.${daywallpaperextension}"
mv -- "$nightwallpaper" "${dwallpapername}-2.${nightwallpaperextension}"
mkdir dynamic-wallpapers/$dwallpapername
echo "Created $dwallpapername folder"
#chmod u+rwx dynamic_wallpapers/$dwallpapername
mv -t dynamic-wallpapers/$dwallpapername "${dwallpapername}-1.${daywallpaperextension}" "${dwallpapername}-2.${nightwallpaperextension}"
echo "Moved wallpapers in $dwallpapername folder"
cd dynamic-wallpapers
echo "<background>
	<starttime>
		<year>2018</year>
		<month>1</month>
		<day>1</day>
		<hour>6</hour>
		<minute>0</minute>
		<second>0</second>
	</starttime>

	<static>
		<file>/usr/share/backgrounds/dynamic_wallpapers/$dwallpapername/"${dwallpapername}-1.${daywallpaperextension}"</file>
		<duration>42300.0</duration>
	</static>

	<transition type=\"overlay\">
		<duration>900.0</duration>
		<from>/usr/share/backgrounds/dynamic_wallpapers/$dwallpapername/"${dwallpapername}-1.${daywallpaperextension}"</from>
		<to>/usr/share/backgrounds/dynamic_wallpapers/$dwallpapername/"${dwallpapername}-2.${nightwallpaperextension}"</to>
	</transition>

	<static>
		<file>/usr/share/backgrounds/dynamic_wallpapers/$dwallpapername/"${dwallpapername}-2.${nightwallpaperextension}"</file>
		<duration>42300.0</duration>
	</static>

	<transition type=\"overlay\">
		<duration>900.0</duration>
    <from>/usr/share/backgrounds/dynamic_wallpapers/$dwallpapername/"${dwallpapername}-2.${nightwallpaperextension}"</from>
		<to>/usr/share/backgrounds/dynamic_wallpapers/$dwallpapername/"${dwallpapername}-1.${daywallpaperextension}"</to>
	</transition>
    </background>" > $dwallpapername.xml
#chmod	u+rwx $dwallpapername.xml
cd ..
cd xml
echo "<?xml version=\"1.0\"?>
<!DOCTYPE wallpapers SYSTEM \"gnome-wp-list.dtd\">
<wallpapers>
  <wallpaper deleted=\"false\">
    <name>$dwallpapername</name>
    <filename>/usr/share/backgrounds/dynamic_wallpapers/$dwallpapername.xml</filename>
    <options>zoom</options>
    <shade_type>solid</shade_type>
    <pcolor>#3465a4</pcolor>
    <scolor>#000000</scolor>
  </wallpaper>
</wallpapers>" > $dwallpapername.xml
#chmod	u+rwx $dwallpapername.xml
echo "Created xml files"
cd ..
git add xml/$dwallpapername.xml Screenshots/$dwallpapername.gif dynamic_wallpapers/$dwallpapername.xml dynamic_wallpapers/$dwallpapername/*
git commit -m ":art: Add $dwallpapername dynamic wallpaper"
echo "Done!"
