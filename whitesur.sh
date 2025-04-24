#!/bin/bash

set -e

scrDir="$(dirname "$(realpath "$0")")"
pm=$1

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

sudo ./tweaks.sh -g -p 60

sudo ./tweaks.sh -f monterey

cd ..

rm -rf WhiteSur-gtk-theme

mkdir -p ~/.themes

for i in "$scrDir"/theme/*;do
	tar -xf $i -C ~/.themes
done

# Setting walls

screen_resolution=$(./screen-res.sh)

git clone https://github.com/vinceliuice/WhiteSur-wallpapers.git

cd WhiteSur-wallpapers

mkdir -p ~/.local/share/gnome-background-properties

echo "Your Screen Resolution is $screen_resolution"

./install-gnome-backgrounds.sh -t whitesur -s "${screen_resolution}"

cd ..

rm -rf WhiteSur-wallpapers

