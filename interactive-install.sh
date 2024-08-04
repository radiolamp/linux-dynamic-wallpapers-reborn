#!/bin/bash
wallpaper_dir="/usr/share/backgrounds/dynamic-wallpapers"
xml_dir="/usr/share/gnome-background-properties/"
git_url="https://github.com/Chillsmeit/Linux_Dynamic_Wallpapers.git/"

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

package() {
    local pkg="$1"
    package="$pkg"
}

check_pkg_mngr() {
    if command_exists apt-get; then
        pkgmngr="apt-get"
        flag="-y"
        install="sudo $pkgmngr install"
        command="$install $flag $package"
    elif command_exists yum; then
        pkgmngr="yum"
        flag="-y"
        install="sudo $pkgmngr install"
        command="$install $flag $package"
    elif command_exists dnf; then
        pkgmngr="dnf"
        flag="-y"
        install="sudo $pkgmngr install"
        command="$install $flag $package"
    elif command_exists zypper; then
        pkgmngr="zypper"
        flag="-y"
        install="sudo $pkgmngr install"
        command="$install $flag $package"
    elif command_exists pacman; then
        pkgmngr="pacman"
        flag="--noconfirm"
        install="sudo $pkgmngr -S"
        command="$install $flag $package"
    elif command_exists emerge; then
        pkgmngr="emerge"
        install="sudo $pkgmngr"
        command="$install $package"
    else
        pkgmngr="unknown"
        flag=""
        install=""
        command=""
    fi
}

install_package(){
    if [ -n "$command" ]; then
        echo "Running: $command"
        eval "$command"
    else
        echo "No valid package manager found."
    fi
}

# Check if both git and whiptail exist
if ! command_exists git; then
    echo "Error: git is not installed."
    package git
	check_pkg_mngr
	install_package
elif ! command_exists whiptail; then
    echo "Error: whiptail is not installed."
    package_manager=$(detect_package_manager)
    if [ "$package_manager" = "yum" ] || [ "$package_manager" = "dnf" ] || [ "$package_manager" = "zypper" ]; then
		package newt
		check_pkg_mngr
		install_package
    fi
	package whiptail
	check_pkg_mngr
	install_package
fi

# Clone .git folder -> Lightweigh checkout
git clone --filter=blob:none --no-checkout "$git_url"

# List files in repo and create array of available walpapers
walpaper_list="$(git --git-dir Linux_Dynamic_Wallpapers/.git ls-tree --full-name --name-only -r HEAD | \
	grep xml/ | \
	sed -e 's/^xml\///' | \
	sed -e 's/.xml//' | \
	sed -e 's/$/,,OFF/' | \
	tr "\n" "," \
)"
IFS=',' read -r -a choiceArray <<< "$walpaper_list"

# Display interactive list to user
user_selection=$(whiptail --title "Select walpapers to install" --checklist \
	"Walpapers:" $LINES $COLUMNS $(( $LINES - 8 )) \
	"${choiceArray[@]}" \
	3>&1 1>&2 2>&3 | sed -e 's/" "/"\n"/')

echo "-----------------"
echo " ✔️ Selection: "
echo "-----------------"
[[ -z "$user_selection" ]] && {
	echo "❌ No selection, exiting..."
	exit 1
} || {
	echo "$user_selection"
}

# Create directories
echo "-----------------"
echo " ⚙️ Configuration"
echo "-----------------"
echo "- Walpapers destionation: $wallpaper_dir"
echo "- XML slideshows destination: $xml_dir"
sudo mkdir -p "$wallpaper_dir"
echo "✅ Created $wallpaper_dir"
sudo mkdir -p "$xml_dir"
echo "✅ Created $xml_dir"

echo "-------------------------"
echo " 🚀 Installing walpapers"
echo "-------------------------"
while IFS= read -r to_install; do
	# Delete quotes in name
	name=$(echo "$to_install" | tr -d '"')
	echo "- Installing $name"

	# List jpeg files to install
	list_to_install=$(git --no-pager --git-dir Linux_Dynamic_Wallpapers/.git show "main:dynamic-wallpapers/$name" | \
		tail -n +3)

	# Install jpeg files
	while IFS= read -r file; do
		echo " Downloading dynamic-wallpapers/$name/$file"
		sudo mkdir -p "$wallpaper_dir/$name"
		git --no-pager --git-dir Linux_Dynamic_Wallpapers/.git show "main:dynamic-wallpapers/$name/$file" | \
			sudo tee "$wallpaper_dir/$name/$file" >/dev/null
	done <<< "$list_to_install"

	# Install xml
	echo " Downloading dynamic-wallpapers/$name.xml"
	git --no-pager --git-dir Linux_Dynamic_Wallpapers/.git show "main:dynamic-wallpapers/$name.xml" | \
		sudo tee "$wallpaper_dir/$name.xml" >/dev/null

	# Install slideshow xml
	echo " Downloading xml/$name.xml"
	git --no-pager --git-dir Linux_Dynamic_Wallpapers/.git show "main:xml/$name.xml" | \
		sudo tee "$xml_dir/$name.xml" >/dev/null
done <<< "$user_selection"

echo
echo "Success !"
echo "Please support the original author of this project on https://github.com/saint-13/Linux_Dynamic_Wallpapers"
