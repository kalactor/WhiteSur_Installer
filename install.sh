#!/bin/bash

set -e 

scrDir="$(dirname "$(realpath "$0")")"
pm=""

if command -v dnf; then
	echo "Operating System: Fedora"
	pm="dnf"
fi

if command -v apt; then
	echo "Operating System: Debian based"
	pm="apt"
fi

sudo $pm update


if ! command -v gnome-tweaks; then
	echo "Installing gnome tweaks..."
	sudo $pm install -y gnome-tweaks
fi

if ! command -v flatpak; then
	echo "Installing Flatpak..."
	sudo $pm install -y flatpak
fi

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

sudo flatpak install -y flathub com.mattjakeman.ExtensionManager

if ! command -v git; then
	echo "Installing git..."
	sudo $pm -y install git
fi

if ! command -v sassc; then
	echo "Installing git..."
	sudo $pm -y install sassc
fi

# Setting Cursor -----------------------------------------

git clone https://github.com/vinceliuice/WhiteSur-cursors.git

cd WhiteSur-cursors

./install.sh

cd ..

rm -rf WhiteSur-cursors

# Setting Icon -------------------------------------------

git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git

cd WhiteSur-icon-theme

./install.sh

cd ..

rm -rf WhiteSur-icon-theme

# Setting Theme ------------------------------------------

git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git

cd WhiteSur-gtk-theme

./install.sh -l -c light -m  -HD --round -N stable

sudo ./tweaks.sh -g -i apple -p 60

sudo ./tweaks.sh -f monterey

cd ..

rm -rf WhiteSur-gtk-theme

mkdir -p ~/.themes

for i in "$scrDir"/theme/*;do
	tar -xf $i -C ~/.themes
done

sudo flatpak override --filesystem=xdg-config/gtk-3.0 && sudo flatpak override --filesystem=xdg-config/gtk-4.0

gsettings set org.gnome.desktop.interface cursor-theme WhiteSur-cursors
gsettings set org.gnome.desktop.interface icon-theme WhiteSur-dark
gsettings set org.gnome.desktop.interface gtk-theme WhiteSur-Dark-solid

# Setting walls

for i in "$scrDir"/walls/*;do
	sudo cp $i /usr/share/backgrounds
done

gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/WhiteSur-light.jpg'
gsettings set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/WhiteSur.jpg'

# Installing Extensions ----------------------------------------

for i in "$scrDir"/ext/ubuntu/*; do
	gnome-extensions install $i
done
