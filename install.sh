#!/bin/bash

set -e 

# Color variables
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No color / Reset


scrDir="$(dirname "$(realpath "$0")")"
pm=""
packages=(
	"gnome-tweaks"
	"flatpak"
	"git"
	"sassc"
	"curl"
	"perl"
	"fbset"
	"python3"
	"xrandr"
)

# Check if /etc/os-release exists
if [ -f /etc/os-release ]; then
	# Source the file to load variables like ID and PRETTY_NAME
	. /etc/os-release

	echo -e "${GREEN}Detected OS: $PRETTY_NAME${NC}"
else
	echo -e "${RED}Cannot detect OS: /etc/os-release not found${NC}"
	exit 1
fi

case "$ID" in
	debian|ubuntu|linuxmint|pop|zorin)
		pm="apt"
		;;
	fedora|centos|rhel)
		pm="dnf"
		;;
	arch)
		pm="pacman"
		;;
	alpine)
		pm="apk"
		;;
	*)
		echo -e "${RED}Can't determine package manager :( [$ID]${NC}"
		exit 1
		;;
esac

echo -e "${GREEN}Detected Package Manager: $pm${NC}"

if [[ $pm == "pacman" ]]; then
	sudo $pm -Syu
else
	sudo $pm update
fi

if [[ "$ID" == "fedora" ]]; then
	packages=("${packages[@]/fbset}")
elif [[ "$ID" == "arch" ]]; then
	packages=("${packages[@]/xrandr}")
fi

for package in "${packages[@]}"; do
	if ! command -v $package &> /dev/null; then
		echo -e "${YELLOW}[$package]${NC} Installing..."

		if [[ $pm == "pacman" ]]; then
			sudo $pm -S --noconfirm --needed $package &> /dev/null
		else
			sudo $pm install -y $package &> /dev/null
		fi
	else
		echo -e "${GREEN}[$package]${NC} is already installed. Moving on..."
	fi
done


sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

sudo flatpak install -y flathub com.mattjakeman.ExtensionManager


# Setting Cursor, Icon, Theme, wallpapers and extensions
./whitesur.sh $pm


# Installing Extensions ----------------------------------------

./ext-installer.sh $pm $ID

sudo flatpak override --filesystem=xdg-config/gtk-3.0 && sudo flatpak override --filesystem=xdg-config/gtk-4.0

gsettings set org.gnome.desktop.interface cursor-theme WhiteSur-cursors
gsettings set org.gnome.desktop.interface icon-theme WhiteSur-light
gsettings set org.gnome.desktop.interface gtk-theme WhiteSur-Light-solid

gsettings set org.gnome.desktop.background picture-uri file:///home/$USER/.local/share/backgrounds/WhiteSur/WhiteSur-timed.xml
gsettings set org.gnome.desktop.background picture-uri-dark file:///home/$USER/.local/share/backgrounds/WhiteSur/WhiteSur-timed.xml


