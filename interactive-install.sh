#!/bin/bash
wallpaper_dir="/usr/share/backgrounds/dynamic-wallpapers"
xml_dir="/usr/share/gnome-background-properties/"
git_url="https://github.com/Chillsmeit/linux-dynamic-wallpapers.git/"

cmd_exists() {
	command -v "$1" >/dev/null 2>&1
}

pkg() {
	local package="$1"
	pkg="$package"
}

check_pm() {
	for pkgmngr in apt-get zypper pacman yum dnf emerge; do
		if cmd_exists $pkgmngr; then
			pm=$pkgmngr
			return
		fi
	done
	pm="unknown"
}

get_install_cmd() {
    case "$pm" in
        yum|dnf|zypper)
            cmd="sudo $pm install -y $pkg"
            ;;
        apt-get)
            cmd="sudo $pm install $pkg -y"
            ;;
        pacman)
            cmd="sudo $pm --noconfirm -S $pkg"
            ;;
        emerge)
            cmd="sudo $pm $pkg"
            ;;
        *)
            cmd="echo 'Package manager not found or unsupported.'"
            ;;
    esac
}

install_pkg() {
    local package="$1"
    local fallback="$2"

    if cmd_exists "$package"; then
        echo "$package is already installed."
        return
    fi

    echo "$package is not installed. Installing $package..."
    pkg "$package"
    check_pm
    get_install_cmd
    if eval $cmd; then
        return
    fi

    echo "Failed to install $package. Trying alternative..."
    if [ -n "$fallback" ]; then
        echo "Attempting to install fallback package: $fallback..."
        pkg "$fallback"
        check_pm
        get_install_cmd
        eval $cmd
    else
        echo "No fallback package provided."
    fi
}

install_pkg git
install_pkg whiptail newt

# Clone .git folder -> Lightweigh checkout
git clone --filter=blob:none --no-checkout "$git_url"

# List files in repo and create array of available walpapers
walpaper_list="$(git --git-dir linux-dynamic-wallpapers/.git ls-tree --full-name --name-only -r HEAD | \
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
	list_to_install=$(git --no-pager --git-dir linux-dynamic-wallpapers/.git show "main:dynamic-wallpapers/$name" | \
		tail -n +3)

	# Install jpeg files
	while IFS= read -r file; do
		echo " Downloading dynamic-wallpapers/$name/$file"
		sudo mkdir -p "$wallpaper_dir/$name"
		git --no-pager --git-dir linux-dynamic-wallpapers/.git show "main:dynamic-wallpapers/$name/$file" | \
			sudo tee "$wallpaper_dir/$name/$file" >/dev/null
	done <<< "$list_to_install"

	# Install xml
	echo " Downloading dynamic-wallpapers/$name.xml"
	git --no-pager --git-dir linux-dynamic-wallpapers/.git show "main:dynamic-wallpapers/$name.xml" | \
		sudo tee "$wallpaper_dir/$name.xml" >/dev/null

	# Install slideshow xml
	echo " Downloading xml/$name.xml"
	git --no-pager --git-dir linux-dynamic-wallpapers/.git show "main:xml/$name.xml" | \
		sudo tee "$xml_dir/$name.xml" >/dev/null
done <<< "$user_selection"

echo
echo "Success !"
echo "Please support the original author of this project on https://github.com/saint-13/Linux_Dynamic_Wallpapers"
